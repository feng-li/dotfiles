#! /bin/bash

# Simple bash script that convert online news as an ebook and update a user 
# Calibre library.

# ARGUMENTS
RECIPE_TITLES=("The New York Times" "The Economist")
OUT_DIR=/home/fli/EBooks/News
OUT_FORMAT=epub

CALIBRE_LIBRARY=/home/fli/.cloud/EBooks
CALIBRE_LIBRARY_SERVER=

# Make DIR
if [[ ! -d $OUT_DIR ]]
then
    echo "$OUT_DIR does not exist, create it."
    mkdir -p $OUT_DIR
fi

# Fetch news and convert to ebook format
for RECIPE_TITLE in "${RECIPE_TITLES[@]}"; do

    DATE=`date '+%Y-%m-%d_%H:%M'`
    ebook-convert "${RECIPE_TITLE}.recipe" ${OUT_DIR}/"${RECIPE_TITLE}"_${DATE}.${OUT_FORMAT}

    # Add Book to Calibre library
    calibredb --with-library  $CALIBRE_LIBRARY add ${OUT_DIR}/"${RECIPE_TITLE}"_${DATE}.${OUT_FORMAT} --duplicates

done

# Delete news older than 5 days from OUT_DIR
find ${OUT_DIR}/*.${OUT_FORMAT} -mtime +5 -exec rm {} \;


exit 0;
