#!/bin/bash

#check nb of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_folder> <output_folder> <n_lines>"
    exit 1
fi

INPUT_FOLDER="$1"
OUTPUT_FOLDER="$2"
N_LINES="$3"

mkdir -p "$OUTPUT_FOLDER"

for file in "$INPUT_FOLDER"/*.txt; do
    if [ -f "$file" ]; then
        OUTPUT_FILE="$OUTPUT_FOLDER/$(basename "$file")"
        head -n "$N_LINES" "$file" > "$OUTPUT_FILE"
        echo "Processed: $file -> $OUTPUT_FILE"
    fi
done

echo "All files processed!"