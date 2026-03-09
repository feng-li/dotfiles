#!/usr/bin/env bash

# Convert biblatex fields to bibtex style
# - date = {YYYY-MM-DD}  -> year = {YYYY}
# - journaltitle -> journal
# Output: file_bibtex.bib

if [ $# -ne 1 ]; then
    echo "Usage: $(basename "$0") file.bib"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Error: file '$FILE' not found."
    exit 1
fi

BASENAME="${FILE%.bib}"
OUTFILE="${BASENAME}_bibtex.bib"

sed -E '
s/\bdate\b[[:space:]]*=[[:space:]]*\{([0-9]{4})[^}]*\}([[:space:]]*,?)/year = {\1}\2/I;
s/\bjournaltitle\b/journal/I
' "$FILE" > "$OUTFILE"

echo "Output written to $OUTFILE"
