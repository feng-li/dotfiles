#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 input.pdf output.pdf"
    exit 1
fi

# Input and output file arguments
input_pdf=$1
margin=$2
output_pdf=${input_pdf}.cropped.pdf

# Temporary files
temp_cropped="temp_cropped.pdf"

# Step 1: Crop margins using pdfCropMargins
echo "Cropping margins with pdfCropMargins..."
pdf-crop-margins -p $margin -o "$temp_cropped" "$input_pdf"

# Step 2: Resize to A4 format using pdfjam
echo "Resizing to A4 format with pdfjam..."
pdfjam --paper a4paper --outfile "$output_pdf" "$temp_cropped"

# Clean up temporary files
echo "Cleaning up..."
rm -f "$temp_cropped"

echo "Done! The output is saved as $output_pdf"
