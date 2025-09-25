#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input_dir> <output_dir> [kmer_size]"
    exit 1
fi

# Read input arguments
INPUT_DIR="$1"
OUTPUT_DIR="$2"
KMER_SIZE="${3:-31}"  # Default kmer size is 31 if not provided

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Process each text file in the input directory
for INPUT_FILE in "$INPUT_DIR"/*.txt; do
    # Check if there are no .txt files
    [ -e "$INPUT_FILE" ] || { echo "No text files found in $INPUT_DIR"; exit 1; }

    # Extract filename without extension
    BASENAME=$(basename "$INPUT_FILE" .txt)
    
    # Define output file
    OUTPUT_FILE="${OUTPUT_DIR}/tree_${BASENAME}.nw"
    
    # Run attotree
    attotree -k "$KMER_SIZE" -L "$INPUT_FILE" -o "$OUTPUT_FILE"
    
    echo "Processed: $INPUT_FILE -> $OUTPUT_FILE"
done

echo "All trees generated successfully!"