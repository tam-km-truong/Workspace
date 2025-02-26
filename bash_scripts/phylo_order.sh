#!/bin/bash

# Input folder containing tree files
TREE_FOLDER="/Users/ktruong/data/tuber_balancing"

# Output folder for phylogenetic order
OUTPUT_FOLDER="/Users/ktruong/data/phylo_order_balancing"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Loop over each tree file in the folder
for tree_file in "$TREE_FOLDER"/tree*.nw; do
    # Extract the tree number (e.g., tree01.nw → 01)
    tree_number=$(basename "$tree_file" | grep -o '[0-9]\+')

    # Define output file
    output_file="$OUTPUT_FOLDER/phylo_order_${tree_number}.txt"

    # Process tree file and save output
    cat "$tree_file" | grep -o '[^,:()]*:' | sed 's/:$//' | grep -Ev '^$' > "$output_file"

    echo "Processed $tree_file → $output_file"
done
