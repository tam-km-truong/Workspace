#!/bin/bash

# Define input and output directories
INPUT_DIR="/Users/ktruong/workspace/Workspace/jupyter_notebook/data/tuber_hll-balancing_full_genome_path"
OUTPUT_DIR="/Users/ktruong/data/tuber_balancing"

# Loop over bin_00.txt to bin_23.txt
for i in $(seq -w 0 23); do
    INPUT_FILE="${INPUT_DIR}/bin_${i}.txt"
    OUTPUT_FILE="${OUTPUT_DIR}/tree$((10#${i} + 1)).nw"
    
    # Run attotree
    attotree -L "$INPUT_FILE" -o "$OUTPUT_FILE"
    
    echo "Processed: $INPUT_FILE -> $OUTPUT_FILE"
done

echo "All trees generated successfully!"
