#! /usr/bin/bash -e

tex_input=$1

if [[ -z $tex_input  ]]; then
    echo "Input tex file required!"
    exit 1;
fi

doc_output=${tex_input%%.*}.docx

bib_file=/home/fli/texmf/bibtex/bib/references-feng.bib

pandoc --bibliography=$bib_file --citeproc $tex_input -o $doc_output
