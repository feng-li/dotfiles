#! /bin/bash

echo "This script diffs on a git-controlled LaTeX source file and generated PDF
between the HEAD and a historical commit.

Make sure you have latexdiff (>= 1.3.3) installed. Otherwise, please go to
https://github.com/ftilmann/ and install the latest version.

sudo apt install latexmk libalgorithm-diff-perl

Make sure you have git-latexdiff installed. Otherwise, please go to
https://gitlab.com/git-latexdiff/git-latexdiff/ and install the latest version.


"
main="$1"
commit="$2"

echo git-latexdiff  $commit  --no-del --latexmk  --ignore-latex-errors --config="PICTUREENV=(?:picture|DIFnomarkup|align|tabular)[\w\d*@]*" --main $main
