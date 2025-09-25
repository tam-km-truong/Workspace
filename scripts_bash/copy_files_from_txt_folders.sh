#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <txt_folder> <destination_path>"
    exit 1
fi

TXT_FOLDER="$1"
DESTINATION_PATH="$2"

# Ensure destination path exists
mkdir -p "$DESTINATION_PATH"

# Process each text file in the folder
for TXT_FILE in "$TXT_FOLDER"/*.txt; do
    [ -e "$TXT_FILE" ] || { echo "No .txt files found in $TXT_FOLDER"; exit 1; }

    while IFS= read -r FILE_PATH; do
        if [ -f "$FILE_PATH" ]; then
            cp "$FILE_PATH" "$DESTINATION_PATH"
            echo "Copied: $FILE_PATH -> $DESTINATION_PATH"
        else
            echo "Warning: File not found - $FILE_PATH"
        fi
    done < "$TXT_FILE"
done

echo "All files copied successfully!"
