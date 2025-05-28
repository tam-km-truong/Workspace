#!/bin/bash

# Folder containing the .txt files
TXT_DIR="/Users/ktruong/data/661k/bakrep_HQ_batches"  # Change this if your .txt files are elsewhere

# Output folder
OUT_DIR="/Users/ktruong/data/661k/bakrep_HQ_batches/dashing_results"
mkdir -p "$OUT_DIR"

# Loop over all txt files
for file in "$TXT_DIR"/*.txt; do
    base=$(basename "$file" .txt)
    union_hll="$OUT_DIR/${base}.hll"
    stats_file="$OUT_DIR/${base}_card.txt"

    echo "Processing $file..."

    # Create the union sketch and save to .hll file
    xargs dashing union -o "$union_hll" < "$file"

    # Use the sketch to estimate cardinality
    dashing card --presketched "$union_hll" > "$stats_file"
done