#!/bin/bash

# adjust these
INPUT_DIR=experiments/034_phylogenetic_placements/e_coli_experiment/tree_min_map
OUTPUT_DIR=experiments/034_phylogenetic_placements/e_coli_experiment/tree_stdized
SCRIPT=python_scripts/postprocess_tree.py
LEAVES=experiments/034_phylogenetic_placements/e_coli_experiment/tree_minmap_leave_order
NODES=experiments/034_phylogenetic_placements/e_coli_experiment/misc

# loop over all .nw files
for input in "$INPUT_DIR"/*.nw; do
    filename=$(basename "$input")        # example: tree1.nw
    treename="${filename%.nw}"            # example: tree1
    output="$OUTPUT_DIR/${treename}.std.nw"
    leaves="$LEAVES_DIR/${treename}.txt"  # matching leaves file
    nodes="$NODES_DIR/${treename}.txt"    # matching nodes file

    echo "Processing $input -> $output (leaves: $leaves, nodes: $nodes)"
    
    python "$SCRIPT" --standardize --midpoint-outgroup --ladderize --name-internals \
      -l "$leaves" -n "$nodes" "$input" "$output"
done