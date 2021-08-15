#$pdflatex = 'pdflatex -draftmode  -synctex=1 -halt-on-error --shell-escape  -file-line-error  %O %S';
$pdf_mode = 4; ## LuaLaTeX
$view = 'none';
#$pdf_previewer = 'xdg-open %O %S';
$bibtex_use = 1.5 # Run biber or bibtex if needed