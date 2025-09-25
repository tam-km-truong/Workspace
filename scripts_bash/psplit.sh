#!/bin/bash

# Usage: ./psplit.sh input.txt 30 [output_dir]
# Splits input.txt into two parts: first 30% of lines, then the rest.

input_file="$1"
percent="$2"
output_dir="${3:-./}"  # default to current directory

# === Help flag ===
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ./psplit.sh <input_file> <percentage> [output_dir]"
    echo
    echo "Randomly shuffles the lines of a file and splits it into two parts:"
    echo "  - First <percentage>% of lines go to part1"
    echo "  - Remaining lines go to part2"
    echo
    echo "Arguments:"
    echo "  input_file     Path to the text file to split"
    echo "  percentage     Number between 0 and 100 (e.g., 30 means 30%/70% split)"
    echo "  output_dir     Optional output directory (default: ./)"
    exit 0
fi

# === Validate input file ===
if [[ ! -f "$input_file" ]]; then
    echo "Error: '$input_file' is not a valid file."
    exit 1
fi

# === Validate percentage ===
if ! [[ "$percent" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: percent must be a number (integer or float)."
    exit 1
fi

if (( $(echo "$percent < 0 || $percent > 100" | bc -l) )); then
    echo "Error: percent must be between 0 and 100."
    exit 1
fi

# === Create output directory if needed ===
mkdir -p "$output_dir"

# === Get total line count ===
total_lines=$(wc -l < "$input_file"| xargs) 
split_line=$(echo "$total_lines * $percent / 100" | bc -l)
split_line=$(printf "%.0f" "$split_line")
if (( split_line < 1 )); then
    split_line=1
fi

if (( split_line == total_lines )); then
    split_line=$(( total_lines - 1 ))
fi

shuffled=$(mktemp)
gshuf "$input_file" > "$shuffled"

base=$(basename "$input_file")
name="${base%.*}"
part1="${output_dir}/${name}_reference_${percent}_percent.txt"
part2="${output_dir}/${name}_remaining_${percent}_percent.txt"

# === Split ===
head -n "$split_line" "$shuffled" > "$part1"
tail -n +"$((split_line + 1))" "$shuffled" > "$part2"

echo "File split at ${percent}% (${split_line} lines out of ${total_lines})"
echo " - $part1"
echo " - $part2"