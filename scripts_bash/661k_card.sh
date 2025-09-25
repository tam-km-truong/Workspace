#!/bin/bash

output_file="results.txt"
> "$output_file"  # Clear the file before writing

for d in /Users/ktruong/data/661k/gziped_full/*; do 
    if ls "$d"/*.fa.gz &>/dev/null; then
        echo "Processing: $d" | tee -a "$output_file"
        ./dashing_s128 card -k 31 <(cat "$d"/*.fa.gz) >> "$output_file"
    else
        echo "Warning: No .fa files in $d" | tee -a "$output_file"
    fi
done
