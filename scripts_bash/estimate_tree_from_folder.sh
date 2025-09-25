#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input_folder> <output_path> [kmer_size (default 31)]"
    exit 1
fi

# Assign input arguments to variables
INPUT_FOLDER="$1"
OUTPUT_PATH="$2"
KMER_SIZE="${3:-31}"  # Default to 31 if not provided

# Check if input folder exists
if [ ! -d "$INPUT_FOLDER" ]; then
    echo "Error: Input folder '$INPUT_FOLDER' not found!"
    exit 1
fi

# Create a temporary file to store the list of genome files
TMP_FILE=$(mktemp)

# Find all files in the input folder (assuming the genome files are in .fa, .fasta, or .fa.gz formats)
find "$INPUT_FOLDER" -type f \( -name "*.fa" -o -name "*.fasta" -o -name "*.fa.gz" \) > "$TMP_FILE"

BASENAME=$(basename "$INPUT_FOLDER")
OUTPUT_PATH="${OUTPUT_PATH%/}/$BASENAME.nw"

# Check if the temporary file contains any genome files
if [ ! -s "$TMP_FILE" ]; then
    echo "No genome files found in the input folder."
    rm "$TMP_FILE"
    exit 1
fi

# Run attotree with the temporary file and specified kmer size
attotree -k "$KMER_SIZE" -L "$TMP_FILE" -o "$OUTPUT_PATH"

# Clean up by removing the temporary file
rm "$TMP_FILE"

echo "Attotree completed successfully. Output saved to '$OUTPUT_PATH'"
