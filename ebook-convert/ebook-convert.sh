#! /bin/bash

# Simple bash script that convert online news as an ebook and update a user Calibre
# library.

# ARGUMENTS
RECIPE_TITLES=("NY Times Global" "The Economist" "Daily Writing Tips")
RECIPE_UPDATE_FREQUENCY=(1 7 7) # Update date frequency in days
RECIPE_CLEAN_FREQUENCY=30 # Delete old books older than x days

OUT_DIR=/home/fli/EBooks/News
OUT_FORMAT=epub

CALIBRE_LIBRARY=/home/fli/.cloud/EBooks # Register to a calibre library if non-empty value is given
CALIBRE_LIBRARY_SERVER= # Send to a calibre server (not implemented yet)

# Make DIR
if [[ ! -d $OUT_DIR ]]
then
    echo "$OUT_DIR does not exist, create it."
    mkdir -p $OUT_DIR
fi

# Fetch news and convert to ebook format
for index in "${!RECIPE_TITLES[@]}"; do

    RECIPE_TITLE=${RECIPE_TITLES[$index]}
    UPDATE_FREQ=${RECIPE_UPDATE_FREQUENCY[$index]}

    RECIPE_EXISTS=`find ${OUT_DIR}/"${RECIPE_TITLE}"*.${OUT_FORMAT} -daystart -mtime -$UPDATE_FREQ`

    if [[ -z  "$RECIPE_EXISTS" ]]
    then

        echo "Converting $RECIPE_TITLE."
        DATE=`date '+%Y-%m-%d_%H:%M'`
        ebook-convert "${RECIPE_TITLE}.recipe" ${OUT_DIR}/"${RECIPE_TITLE}"_${DATE}.${OUT_FORMAT}

        # Add ebooks to the calibre library if a calibre librrary is set.
        if [[ ! -z $CALIBRE_LIBRARY ]]
        then
            calibredb --with-library  $CALIBRE_LIBRARY add ${OUT_DIR}/"${RECIPE_TITLE}"_${DATE}.${OUT_FORMAT} --duplicates
        fi

    else
        echo "Skip converting $RECIPE_TITLE. The following most recent ebooks exist:"
        echo "$RECIPE_EXISTS"
    fi


done

# Delete news older than certain days from OUT_DIR
find ${OUT_DIR}/*.${OUT_FORMAT} -mtime +$RECIPE_CLEAN_FREQUENCY -exec rm {} \;

exit 0;
