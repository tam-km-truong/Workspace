#!/bin/bash

# Check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_folder> <output_folder>"
    exit 1
fi

# Input and output folders
INPUT_FOLDER="$1"
OUTPUT_FOLDER="$2"

# Check if input folder exists
if [ ! -d "$INPUT_FOLDER" ]; then
    echo "Error: Input folder '$INPUT_FOLDER' does not exist."
    exit 1
fi

# Create output folder if it does not exist
mkdir -p "$OUTPUT_FOLDER"

# Process each .txt file in the input folder
for TXT_FILE in "$INPUT_FOLDER"/*.txt; do
    # Skip if no .txt files exist
    [ -e "$TXT_FILE" ] || { echo "No .txt files found in $INPUT_FOLDER"; exit 1; }

    # Extract filename without extension
    FILE_NAME=$(basename "$TXT_FILE" .txt)

    # Define output compressed file path
    OUTPUT_FILE="${OUTPUT_FOLDER}/${FILE_NAME}.tar.xz"

    # Run the miniphy2 compress command
    ./miniphy2 compress -p "${FILE_NAME}/" -lfo "$OUTPUT_FILE" "$TXT_FILE"

    echo "Compressed: $TXT_FILE -> $OUTPUT_FILE"
done

echo "All .txt files processed!"
