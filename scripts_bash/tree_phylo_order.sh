#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <tree_folder> <output_folder>"
    exit 1
fi

# Read input arguments
TREE_FOLDER="$1"
OUTPUT_FOLDER="$2"

# Ensure output folder exists
mkdir -p "$OUTPUT_FOLDER"

# Loop over each tree file in the folder
for tree_file in "$TREE_FOLDER"/*.nw; do
    # Check if there are no tree files
    [ -e "$tree_file" ] || { echo "No tree files found in $TREE_FOLDER"; exit 1; }

    # Extract the tree number (e.g., tree01.nw → 01)
    filename=$(basename "$tree_file" .nw )

    # Define output file
    output_file="$OUTPUT_FOLDER/phylo_order_${filename}.txt"

    # Process tree file and save output
    grep -o '[^,:()]*:' "$tree_file" | sed 's/:$//' | grep -Ev '^$' > "$output_file"

    echo "Processed $tree_file → $output_file"
done

echo "All phylogenetic orders extracted successfully!"
