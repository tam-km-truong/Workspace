import sys
import os
from itertools import accumulate

def split_into_increasing_sublists(lst, n):
    """
    Splits a list into `n` sublists where the sizes gradually increase proportionally.

    :param lst: The input list.
    :param n: The number of sublists.
    :return: A list of `n` sublists with increasing sizes.
    """
    total = len(lst)

    # Compute increasing proportions (e.g., 1, 2, 3, ..., n)
    proportions = [(i+1) for i in range(n)]
    total_ratio = sum(proportions)

    # Compute the approximate sizes of each sublist based on the total length
    sizes = [round((p * total) / total_ratio) for p in proportions]

    # Adjust the sizes to make sure the sum equals the total length
    diff = total - sum(sizes)
    for i in range(abs(diff)):
        sizes[i % n] += (1 if diff > 0 else -1)

    # Split the list based on computed sizes
    sublists = []
    start = 0
    for size in sizes:
        sublists.append(lst[start:start+size])
        start += size
    
    return sublists

def split_into_increasing_bins(input_file, output_dir, bin_count):
    """
    Splits the contents of an input file into bins with gradually increasing sizes,
    and writes them to the specified output directory.
    
    :param input_file: Path to the input file.
    :param output_dir: Directory to store the resulting bins.
    :param bin_count: Number of bins to split the list into.
    """
    # Read the input file
    with open(input_file, 'r') as f:
        lst = f.readlines()
    
    # Remove newline characters from each line
    lst = [line.strip() for line in lst]
    
    # Split the list into increasing sublists
    sublists = split_into_increasing_sublists(lst, bin_count)
    
    # Write the sublists to the output directory
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for i, sublist in enumerate(sublists):
        if i<9:
            output_file = os.path.join(output_dir, f"bin_0{i+1}.txt")
        else:
            output_file = os.path.join(output_dir, f"bin_{i+1}.txt")
        with open(output_file, 'w') as f:
            f.write("\n".join(sublist) + "\n")
        print(f"Bin {i+1} written to {output_file}")

def main():
    if len(sys.argv) != 4:
        print("Usage: python split_into_bins.py <input_file> <output_dir> <bin_count>")
        sys.exit(1)

    # Get arguments from command line
    input_file = sys.argv[1]  # Input file
    output_dir = sys.argv[2]  # Output directory
    bin_count = int(sys.argv[3])  # Number of bins

    # Call the function to split the file into bins
    split_into_increasing_bins(input_file, output_dir, bin_count)

if __name__ == "__main__":
    main()
