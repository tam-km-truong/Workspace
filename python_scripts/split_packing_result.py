import os
import re
import sys

def split_bins(input_file, output_folder):
    """
    Reads a file containing bin information and creates separate text files for each bin.

    :param input_file: Path to the input text file.
    :param output_folder: Path to the output directory.
    """
    os.makedirs(output_folder, exist_ok=True)

    with open(input_file, "r") as file:
        for line in file:
            match = re.match(r"Bin\s(\d+):\s(.+);\sCardinality:", line)
            if match:
                bin_idx = match.group(1)  # Extract bin index
                genomes = match.group(2).split(", ")  # Split genome names

                output_file = os.path.join(output_folder, f"bin{bin_idx}.txt")

                # Write genomes to the output file
                with open(output_file, "w") as out:
                    out.write("\n".join(genomes) + "\n")
                
                print(f"Created: {output_file}")

    print("Processing completed!")

# Command-line usage
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python split_packing_result.py <input_txt_file> <output_folder>")
        sys.exit(1)

    input_txt = sys.argv[1]
    output_dir = sys.argv[2]
    split_bins(input_txt, output_dir)
