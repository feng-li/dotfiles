#!/usr/bin/env bash

set -euo pipefail

# --- Function: Print usage and installation instructions ---
print_help() {
    echo "This script diffs on a git-controlled LaTeX source file and generated PDF
between the HEAD and a historical commit.

Make sure you have latexdiff (>= 1.3.3) installed. Otherwise, please go to
https://github.com/ftilmann/latexdiff/ and install the latest version.

Make sure you have git-latexdiff installed. Otherwise, please go to
https://gitlab.com/git-latexdiff/git-latexdiff/ and install the latest version.

You may also install dependencies with:
  sudo apt install latexmk libalgorithm-diff-perl

Usage:
  $0 <main_tex> <commit_hash> [noconfig] [--underwave]

Examples:
  $0 main.tex f88fa29d18f0bbc0f1            # blue additions by default
  $0 main.tex f88fa29d18f0bbc0f1 noconfig   # disable custom config
  $0 main.tex f88fa29d18f0bbc0f1 --underwave

By default, --config and blue-only additions are ENABLED.
Blue-only mode preserves the document font and marks additions only by changing
their text color to blue. Pass --underwave to use latexdiff's default markup.
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
BLUE_ONLY=true
BLUE_ONLY_PREAMBLE=""

for option in "${@:3}"; do
    case "$option" in
        noconfig|--no-config)
            DISABLE_CONFIG=true
            ;;
        blueonly|--blue-only)
            BLUE_ONLY=true
            ;;
        underwave|--underwave)
            BLUE_ONLY=false
            ;;
        *)
            echo "Unknown option: $option" >&2
            print_help >&2
            exit 2
            ;;
    esac
done

# --- 2. Resolve real paths ---
GIT_LATEXDIFF_PATH="$(realpath "$(command -v git-latexdiff)")"
MAIN_TEX_PATH=$MAIN_TEX
DIFF_PDF="diff_${COMMIT_HASH}.pdf"

# --- 3. Build base command ---
CMD=(
    "$GIT_LATEXDIFF_PATH" "$COMMIT_HASH"
    --latexmk
    --ignore-latex-errors
    --no-del
    --main "$MAIN_TEX_PATH"
    --output "$DIFF_PDF"
)

# --- 4. Optionally use blue text without underlining or font changes ---
if [[ "$BLUE_ONLY" == true ]]; then
    BLUE_ONLY_PREAMBLE="$(mktemp "${TMPDIR:-/tmp}/git-latexdiff-blue-only.XXXXXX")"
    trap 'rm -f -- "$BLUE_ONLY_PREAMBLE"' EXIT
    BLUE_ONLY_PREAMBLE_LINES=(
        '% Custom latexdiff preamble: blue additions without underlining or font changes.'
        '\RequirePackage{color}'
        '\providecommand{\DIFadd}[1]{{\protect\color{blue}#1}}'
        '\providecommand{\DIFdel}[1]{}'
        '\providecommand{\DIFaddbegin}{}'
        '\providecommand{\DIFaddend}{}'
        '\providecommand{\DIFdelbegin}{}'
        '\providecommand{\DIFdelend}{}'
        '\providecommand{\DIFmodbegin}{}'
        '\providecommand{\DIFmodend}{}'
        '\providecommand{\DIFaddFL}[1]{\DIFadd{#1}}'
        '\providecommand{\DIFdelFL}[1]{\DIFdel{#1}}'
        '\providecommand{\DIFaddbeginFL}{}'
        '\providecommand{\DIFaddendFL}{}'
        '\providecommand{\DIFdelbeginFL}{}'
        '\providecommand{\DIFdelendFL}{}'
        '\RequirePackage{listings}'
        '\lstdefinelanguage{DIFcode}{'
        '  morecomment=[il]{\%DIF\ <\ },'
        '  moredelim=[il][\color{blue}]{\%DIF\ >\ }'
        '}'
        '\lstdefinestyle{DIFverbatimstyle}{'
        '  language=DIFcode,basicstyle=\ttfamily,columns=fullflexible,keepspaces=true'
        '}'
        '\lstnewenvironment{DIFverbatim}[1][]{\lstset{style=DIFverbatimstyle}}{}'
        '\lstnewenvironment{DIFverbatim*}[1][]{\lstset{style=DIFverbatimstyle,showspaces=true}}{}'
    )
    printf '%s\n' "${BLUE_ONLY_PREAMBLE_LINES[@]}" > "$BLUE_ONLY_PREAMBLE"
    CMD+=( --preamble="$BLUE_ONLY_PREAMBLE" )
    echo "Blue-only additions ENABLED (no underline or font change)."
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
