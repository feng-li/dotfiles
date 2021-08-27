#$pdflatex = 'pdflatex -draftmode  -synctex=1 -halt-on-error --shell-escape  -file-line-error  %O %S';
$pdf_mode = 5; ## LuaLaTeX (4) is slower than XeLaTeX(5)
$view = 'none';
#$pdf_previewer = 'xdg-open %O %S';
$bibtex_use = 1.5 # Run biber or bibtex if needed