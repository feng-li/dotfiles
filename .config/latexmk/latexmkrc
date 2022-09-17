#$pdflatex = 'pdflatex -draftmode  -synctex=1 -halt-on-error --shell-escape  -file-line-error  %O %S';

$pdf_mode = 5; ## LuaLaTeX (4) is slower than XeLaTeX(5)
$view = 'none';
# $pdf_previewer = 'xdg-open %O %S';

$bibtex_use = 2;  # Run biber or bibtex if needed

# biber by default assumes we're running a more modern compiler like XeLaTeX or LuaTeX on
# the backend, which isn't true in arXiv submission
$biber = 'biber --output-safechars %O %S';