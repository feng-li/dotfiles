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
  $0 <main_tex> <commit_hash> [noconfig]

Examples:
  $0 main.tex f88fa29d18f0bbc0f1
  $0 main.tex f88fa29d18f0bbc0f1 noconfig   # disable custom config

By default, --config is ENABLED.
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
DISABLE_CONFIG="${3:-}"

# --- 2. Resolve real paths ---
GIT_LATEXDIFF_PATH="$(realpath "$(command -v git-latexdiff)")"
MAIN_TEX_PATH=$MAIN_TEX

# --- 3. Build base command ---
CMD=(
    "$GIT_LATEXDIFF_PATH" "$COMMIT_HASH"
    --latexmk
    --ignore-latex-errors
    --no-del
    --main "$MAIN_TEX_PATH"
)

# --- 4. Enable config by default unless 'noconfig' is passed ---
if [[ "$DISABLE_CONFIG" == "noconfig" ]]; then
    echo "ℹ️  Running without --config (disabled manually)."
else
    CMD+=( --config='PICTUREENV=(?:picture|DIFnomarkup|align|tabular)[\\w\\d*@]*' )
    echo "✅  Custom --config ENABLED (default)."
fi

# --- 5. Execute command ---
echo "Running: ${CMD[*]}"
"${CMD[@]}"
