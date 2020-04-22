$pdflatex = "xelatex  -synctex=1 -halt-on-error --shell-escape  -file-line-error  %O %S";
$pdf_mode = "1";  # tex -> pdf
$view = 'none';   # do not use pdf viewer