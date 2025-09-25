#!/bin/bash

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_folder> <genome_folder> <output_folder>"
    exit 1
fi

INPUT_FOLDER="$1"
GENOME_FOLDER="$2"
OUTPUT_FOLDER="$3"

# Ensure input and genome folders exist
if [ ! -d "$INPUT_FOLDER" ]; then
    echo "Error: Input folder '$INPUT_FOLDER' not found!"
    exit 1
fi

if [ ! -d "$GENOME_FOLDER" ]; then
    echo "Error: Genome folder '$GENOME_FOLDER' not found!"
    exit 1
fi

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Build a lookup table of genome files
declare -A GENOME_MAP

echo "Indexing genome files in $GENOME_FOLDER..."
while IFS= read -r filepath; do
    filename=$(basename "$filepath")
    name="${filename%%.*}" # Extract genome name (before first dot)
    GENOME_MAP["$name"]="$filepath"
done < <(find "$GENOME_FOLDER" -type f \( -name "*.fa" -o -name "*.fasta" -o -name "*.fa.gz" -o -name "*.hll" \))

echo "Indexing completed! Found ${#GENOME_MAP[@]} genome files."

# Process each .txt file in the input folder
for txt_file in "$INPUT_FOLDER"/*.txt; do
    if [ -f "$txt_file" ]; then
        filename=$(basename "$txt_file" .txt)
        OUTPUT_FILE="$OUTPUT_FOLDER/${filename}_paths.txt"

        echo "Processing $txt_file → $OUTPUT_FILE"

        # Clear the output file
        > "$OUTPUT_FILE"

        # Read each genome name and look it up in the map
        while IFS= read -r genome; do
            if [[ -n "${GENOME_MAP[$genome]}" ]]; then
                echo "${GENOME_MAP[$genome]}" >> "$OUTPUT_FILE"
            else
                echo "Warning: Genome file for '$genome' not found!" >&2
            fi
        done < "$txt_file"

        echo "Genome file paths saved to '$OUTPUT_FILE'"
    fi
done

echo "All files processed!"