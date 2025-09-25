# Define the file paths
text_folder=experiments/034_phylogenetic_placements/e_coli_experiment/tree_minmap_leave_order
order_file=experiments/034_phylogenetic_placements/e_coli_experiment/tree_10k_genomes/leaves_order.txt
combined_file=experiments/034_phylogenetic_placements/e_coli_experiment/combined.txt

# Empty the output file first
> $combined_file

# Verify the necessary files and folders exist
if [ ! -f "$order_file" ]; then
    echo "Error: Order file does not exist!"
    exit 1
fi

if [ ! -d "$text_folder" ]; then
    echo "Error: Text folder does not exist!"
    exit 1
fi

# Process each filename in the order file
while read -r filename; do
    if [ -f "${text_folder}/${filename}.txt" ]; then
        cat "${text_folder}/${filename}.txt" >> $combined_file
    else
        echo "$filename" >> $combined_file
    fi
done < $order_file
