#!/usr/bin/env bash

set -euo pipefail

# git-latexdiff exports tracked files only. Copy untracked supporting assets
# into each temporary checkout, preserving assets from the historical commit.
copy_untracked_assets() {
    python3 - "$1" "$2" <<'PY'
from pathlib import Path, PurePosixPath
import os
import re
import shutil
import subprocess
import sys

source_root = Path(sys.argv[1]).resolve()
checkout_root = Path.cwd()
for _ in PurePosixPath(sys.argv[2]).parts:
    checkout_root = checkout_root.parent
extensions = {'.pdf', '.png', '.jpg', '.jpeg', '.eps', '.ps', '.svg',
              '.bib', '.bst', '.cls', '.sty', '.bbx', '.cbx'}
paths = subprocess.check_output(
    ['git', 'ls-files', '--others', '--exclude-standard', '-z'], cwd=source_root
).split(b'\0')
candidates = {Path(os.fsdecode(raw)) for raw in paths if raw}
# Globally ignored PDFs are also absent from git archives. Include literal
# figure references without copying unrelated ignored build directories.
texts = [p.read_text(errors='replace') for p in checkout_root.rglob('*.tex')]
graphics_roots = [Path.cwd()]
for text in texts:
    for group in re.findall(r'\\graphicspath\{((?:\{[^}]*\})+)\}', text):
        graphics_roots.extend(Path.cwd() / p for p in re.findall(r'\{([^}]*)\}', group))
for text in texts:
    references = re.findall(
        r'\\(?:includegraphics|includepdf)\*?(?:\[[^]]*\])?\{([^}]+)\}', text
    )
    for reference in references:
        if '\\' in reference or Path(reference).is_absolute():
            continue
        for base in graphics_roots:
            destination = Path(os.path.normpath(base / reference))
            try:
                relative = destination.relative_to(checkout_root)
            except ValueError:
                continue
            choices = [relative] if relative.suffix else [
                relative.with_suffix(ext) for ext in ['.pdf', '.png', '.jpg', '.jpeg', '.eps']
            ]
            for choice in choices:
                if (source_root / choice).is_file():
                    candidates.add(choice)
                    break
copied = 0
for relative in sorted(candidates):
    if relative.suffix.lower() not in extensions:
        continue
    source = source_root / relative
    destination = checkout_root / relative
    if not source.is_file() or destination.exists() or destination.is_symlink():
        continue
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination, follow_symlinks=True)
    copied += 1
print(f'Copied {copied} supporting assets into {checkout_root}.')
PY
}

if [[ "${1:-}" == "--copy-untracked-assets" ]]; then
    [[ $# -eq 3 ]] || { echo 'Internal error: asset copy expects a repository and prefix.' >&2; exit 2; }
    copy_untracked_assets "$2" "$3"
    exit 0
fi

# --- Internal filter helpers for the generated TeX checkout ---
normalize_pdf_assets() {
    local target="$1"
    local target_dir asset_ref asset version rewritten_asset normalized_asset rewrite_log
    local -a asset_refs=()

    if ! command -v gs >/dev/null 2>&1 || ! command -v qpdf >/dev/null 2>&1; then
        echo "Warning: Ghostscript and qpdf are required to normalize PDF 1.7 figures." >&2
        return
    fi

    target_dir="$(dirname -- "$target")"
    mapfile -t asset_refs < <(
        perl -ne '
            while (/\\(?:includegraphics|includepdf)(?:\[[^]]*\])?\{([^}]+)\}/g) {
                print "$1\n";
            }
        ' "$target" | sort -u
    )

    for asset_ref in "${asset_refs[@]}"; do
        case "$asset_ref" in
            *.pdf) ;;
            *) asset_ref="${asset_ref}.pdf" ;;
        esac

        if [[ "$asset_ref" == /* ]]; then
            asset="$asset_ref"
        else
            asset="$target_dir/$asset_ref"
        fi
        [[ -f "$asset" ]] || continue

        version="$(LC_ALL=C sed -n '1s/^%PDF-\([0-9][0-9.]*\).*/\1/p' "$asset")"
        [[ -n "$version" ]] || continue
        if ! awk -v version="$version" 'BEGIN { exit !(version > 1.5) }'; then
            continue
        fi

        rewritten_asset="${asset}.git-latexdiff-rewritten.$$"
        normalized_asset="${asset}.git-latexdiff-normalized.$$"
        rewrite_log="${asset}.git-latexdiff-rewrite.$$"
        if ! gs -q -dSAFER -dBATCH -dNOPAUSE \
            -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
            -dPDFSETTINGS=/prepress -sOutputFile="$rewritten_asset" "$asset" \
            2>"$rewrite_log"; then
            sed -n '1,20p' "$rewrite_log" >&2
            rm -f -- "$rewritten_asset" "$normalized_asset" "$rewrite_log"
            echo "Failed to rewrite PDF asset: $asset" >&2
            exit 1
        fi
        if ! qpdf --warning-exit-0 "$rewritten_asset" "$normalized_asset" \
            2>>"$rewrite_log"; then
            sed -n '1,40p' "$rewrite_log" >&2
            rm -f -- "$rewritten_asset" "$normalized_asset" "$rewrite_log"
            echo "Failed to normalize PDF asset: $asset" >&2
            exit 1
        fi
        rm -f -- "$rewritten_asset" "$rewrite_log"
        mv -- "$normalized_asset" "$asset"
        echo "Rewrote PDF $asset_ref from version $version to 1.5 for xdvipdfmx."
    done
}

apply_addition_color_filter() {
    local mode="$1"
    local color="$2"
    local target="$3"

    if [[ ! -f "$target" ]]; then
        echo "Addition-color filter target not found: $target" >&2
        exit 1
    fi

    LATEXDIFF_ADDITION_COLOR="$color" \
    LATEXDIFF_COLOR_ONLY="$([[ "$mode" == color-only ]] && printf 1 || printf 0)" \
        perl -i -pe '
            if (/%DIF PREAMBLE/ && /\\color\{blue\}/) {
                my $replacement = "\\color{" . $ENV{LATEXDIFF_ADDITION_COLOR} . "}";
                s/\\color\{blue\}/$replacement/g;
                if ($ENV{LATEXDIFF_COLOR_ONLY} eq "1") {
                    s/\s*\\sffamily//g;
                    s/\s*\\sf(?=\s)//g;
                }
            }
        ' "$target"
}

apply_missing_figure_filter() {
    local target="$1"
    local preamble
    preamble="$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")/git-latexdiff-missing-figures.tex"
    if [[ ! -r "$preamble" ]]; then
        echo "Missing figure-fallback helper: $preamble" >&2
        exit 1
    fi
    LATEXDIFF_MISSING_FIGURE_PREAMBLE="$preamble" perl -0777 -i -pe '
        BEGIN {
            open my $fh, "<", $ENV{LATEXDIFF_MISSING_FIGURE_PREAMBLE} or die $!;
            local $/;
            $preamble = <$fh>;
        }
        unless (/git-latexdiff missing-figure fallback begin/) {
            s/(?=\\begin\{document\})/$preamble\n/
                or die "Cannot insert missing-figure fallback: no begin{document}\n";
        }
    ' "$target"
}

if [[ "${1:-}" == "--filter-generated-tex" ]]; then
    if [[ $# -ne 4 && $# -ne 5 ]]; then
        echo "Internal error: generated-TeX filter expects a mode, color, TeX file, and optional missing-figure flag." >&2
        exit 2
    fi
    normalize_pdf_assets "$4"
    if [[ "$2" == color-only || "$2" == underwave ]]; then
        apply_addition_color_filter "$2" "$3" "$4"
    else
        echo "Internal error: unknown generated-TeX filter mode: $2" >&2
        exit 2
    fi
    if [[ "${5:-true}" == true ]]; then
        apply_missing_figure_filter "$4"
    fi
    exit 0
fi

# --- Function: Print usage and installation instructions ---
print_help() {
    echo "This script diffs a git-controlled LaTeX source file and generates a PDF
between the working tree and a historical commit.

Make sure you have latexdiff (>= 1.3.3) installed. Otherwise, please go to
https://github.com/ftilmann/latexdiff/ and install the latest version.

Make sure you have git-latexdiff installed. Otherwise, please go to
https://gitlab.com/git-latexdiff/git-latexdiff/ and install the latest version.

You may also install dependencies with:
  sudo apt install latexmk libalgorithm-diff-perl

Usage:
  $0 <main_tex> <commit_hash> [options]

Options:
  --additions-only    Hide deletions (default; alias: --no-del)
  --show-deletions    Strike out deletions and underwave additions, keeping
                     the document typeface
  --allow-missing-figures
                     Replace missing includegraphics images with labelled
                     placeholders in the diff PDF only (default)
  --strict-figures    Fail on missing images instead of using placeholders
  --color COLOR       Addition color (default: blue)
  --color-only        Override automatic style with legacy color-only markup
  --underwave         Use wavy underlining instead of color-only markup
  noconfig            Disable the default custom latexdiff configuration

Examples:
  $0 main.tex f88fa29d18f0bbc0f1            # blue additions by default
  $0 main.tex f88fa29d18f0bbc0f1 --color red
  $0 main.tex f88fa29d18f0bbc0f1 --color=ForestGreen
  $0 main.tex f88fa29d18f0bbc0f1 --show-deletions
  $0 main.tex f88fa29d18f0bbc0f1 --show-deletions --allow-missing-figures
  $0 main.tex f88fa29d18f0bbc0f1 --strict-figures
  $0 main.tex f88fa29d18f0bbc0f1 noconfig   # disable custom config
  $0 main.tex f88fa29d18f0bbc0f1 --underwave --color red

By default, deletions are hidden; --show-deletions includes them in the diff.
Missing figures become labelled placeholders by default; --strict-figures
restores missing-image errors. Other LaTeX errors always fail normally.
If both deletion options are supplied, the last one takes precedence.
The --config option is ENABLED. Additions-only mode defaults to color-only
markup; --show-deletions defaults to UNDERLINE (struck-out deletions and
underwaved additions). Both defaults preserve the document typeface.
Use --color-only or --underwave to override the automatic markup style.
COLOR may be an xcolor name or mixture such as blue!70!black.
This script runs git-latexdiff using full path resolution.
"
}

# --- If no arguments are provided, print help and exit ---
if [[ $# -lt 2 ]]; then
    print_help
    exit 0
fi

# --- 1. Parse input arguments ---
MAIN_TEX="$1"
COMMIT_HASH="$2"
DISABLE_CONFIG=false
COLOR_ONLY=auto
ADDITIONS_ONLY=true
ALLOW_MISSING_FIGURES=true
ADDITION_COLOR=blue

shift 2
while [[ $# -gt 0 ]]; do
    case "$1" in
        --allow-missing-figures)
            ALLOW_MISSING_FIGURES=true
            shift
            ;;
        --strict-figures)
            ALLOW_MISSING_FIGURES=false
            shift
            ;;
        --additions-only|--no-del)
            ADDITIONS_ONLY=true
            shift
            ;;
        --show-deletions)
            ADDITIONS_ONLY=false
            shift
            ;;
        noconfig|--no-config)
            DISABLE_CONFIG=true
            shift
            ;;
        blueonly|--blue-only|--color-only)
            COLOR_ONLY=true
            shift
            ;;
        underwave|--underwave)
            COLOR_ONLY=false
            shift
            ;;
        --color)
            if [[ $# -lt 2 ]]; then
                echo "Missing value for --color." >&2
                exit 2
            fi
            ADDITION_COLOR="$2"
            shift 2
            ;;
        --color=*)
            ADDITION_COLOR="${1#--color=}"
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            print_help >&2
            exit 2
            ;;
    esac
done

# Resolve automatic styling only after all mode options have been parsed.
if [[ "$COLOR_ONLY" == auto ]]; then
    COLOR_ONLY="$ADDITIONS_ONLY"
fi

if [[ ! "$ADDITION_COLOR" =~ ^[[:alpha:]][[:alnum:]_.-]*(![[:digit:]]{1,3}(![[:alpha:]][[:alnum:]_.-]*)?)*$ ]]; then
    echo "Invalid color expression: $ADDITION_COLOR" >&2
    exit 2
fi

# --- 2. Resolve real paths ---
GIT_LATEXDIFF_PATH="$(realpath "$(command -v git-latexdiff)")"
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
GIT_ROOT="$(git rev-parse --show-toplevel)"
GIT_PREFIX="$(git rev-parse --show-prefix)"
MAIN_TEX_PATH=$MAIN_TEX
MAIN_TEX_GIT_REL="$(realpath --relative-to="$GIT_ROOT" "$MAIN_TEX_PATH")"
MAIN_TEX_BASENAME="$(basename -- "$MAIN_TEX_PATH")"
DIFF_PDF="${MAIN_TEX_BASENAME%.*}_diff_${COMMIT_HASH}.pdf"

# --- 3. Build base command ---
CMD=(
    "$GIT_LATEXDIFF_PATH" "$COMMIT_HASH" --
    --latexmk
    --whole-tree
    --latexopt '-pdflatex=pdflatex -nobibtexfudge -halt-on-error'
    --math-markup=whole
    --main "$MAIN_TEX_PATH"
    --output "$DIFF_PDF"
)
printf -v PREPARE_ASSETS_COMMAND '%q %q %q %q' \
    "$SCRIPT_PATH" --copy-untracked-assets "$GIT_ROOT" "$GIT_PREFIX"
CMD+=( --prepare "$PREPARE_ASSETS_COMMAND" )
if [[ "$ADDITIONS_ONLY" == true ]]; then
    CMD+=( --no-del )
    echo "Additions-only diff ENABLED (default; deletions hidden)."
else
    echo "Full diff ENABLED (additions and deletions shown)."
fi

# --- 4. Filter generated TeX and normalize newer included PDFs ---
if [[ "$COLOR_ONLY" == true ]]; then
    FILTER_MODE=color-only
    CMD+=( --type=CFONT )
    echo "Color-only additions ENABLED in $ADDITION_COLOR (no underline or font change)."
else
    FILTER_MODE=underwave
    CMD+=( --type=UNDERLINE )
    echo "Underwave additions ENABLED in $ADDITION_COLOR; deletions use strikeout (document typeface preserved)."
fi
printf -v GENERATED_TEX_FILTER_COMMAND '%q %q %q %q %q %q' \
    "$SCRIPT_PATH" --filter-generated-tex "$FILTER_MODE" \
    "$ADDITION_COLOR" "$MAIN_TEX_GIT_REL" "$ALLOW_MISSING_FIGURES"
CMD+=( --filter "$GENERATED_TEX_FILTER_COMMAND" )
if [[ "$ALLOW_MISSING_FIGURES" == true ]]; then
    echo "WARNING: Missing figures will become labelled placeholders in this diff preview." >&2
fi

# --- 5. Enable config by default unless 'noconfig' is passed ---
if [[ "$DISABLE_CONFIG" == true ]]; then
    echo "ℹ️  Running without --config (disabled manually)."
else
    CMD+=( --config="PICTUREENV=(?:picture|DIFnomarkup|align|tabular)[\\w\\d*@]*")
    echo "✅  Custom --config ENABLED (default)."
fi

# --- 6. Execute command ---
echo "Running: ${CMD[*]}"
"${CMD[@]}"

# --- 7. Open output PDF ---
if [[ -f ${DIFF_PDF} ]]; then
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$DIFF_PDF" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        open "$DIFF_PDF" >/dev/null 2>&1 &
    else
        echo "PDF generated but cannot auto-open (no xdg-open or open found)."
    fi
else
    echo "No ${DIFF_PDF} found — check LaTeX compilation errors."
fi
