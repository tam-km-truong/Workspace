import os
import subprocess
import glob
import argparse
import tempfile
import csv

def get_cardinality(sketch):
    """
    Get the cardinality of a given HLL sketch using Dashing.
    
    :param sketch: Path to the HLL sketch file.
    :return: Estimated cardinality (float).
    """
    result = subprocess.run(["dashing", "card", "--presketched", sketch], 
                            capture_output=True, text=True, check=True)
    result = result.stdout.strip().split('\t')[-1]
    return float(result)

def merge_sketches(sketches):
    """
    Merge multiple HLL sketches into a single sketch using a single `dashing union` command.

    :param sketches: List of sketch file paths.
    :return: Path to the final merged sketch.
    """
    if len(sketches) == 1:
        return sketches[0]  # No merging needed

    # Create a temporary file for merged sketch
    merged_sketch = tempfile.NamedTemporaryFile(suffix=".hll", delete=False).name

    # Run dashing union in one command
    subprocess.run(["dashing", "union", "-o", merged_sketch] + sketches, check=True)

    return merged_sketch

def process_sketch_files(input_folder, output_csv):
    """
    Process each text file in the input folder, merge sketches, and compute cardinality.
    
    :param input_folder: Folder containing text files with paths to HLL sketches.
    :param output_csv: Path to save the final CSV result.
    """
    with open(output_csv, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["filename", "cardinality"])  # Write header

        for txt_file in glob.glob(os.path.join(input_folder, "*.txt")):
            base_name = os.path.basename(txt_file)

            with open(txt_file, "r") as f:
                sketches = [line.strip() for line in f if line.strip()]
            
            if not sketches:
                print(f"Warning: No sketches found in {txt_file}, skipping.")
                continue
            
            merged_sketch = merge_sketches(sketches)
            cardinality = get_cardinality(merged_sketch)
            writer.writerow([base_name, cardinality])

            print(f"Processed {txt_file}: Cardinality = {cardinality}")

            # Cleanup temporary merged sketch
            if merged_sketch not in sketches:  # Only remove if it was created
                os.remove(merged_sketch)

    print(f"Results saved to {output_csv}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Merge genome sketches iteratively and compute cardinality.")
    parser.add_argument("input_folder", help="Folder containing text files with genome sketch paths.")
    parser.add_argument("output_csv", help="Path to save the result CSV file.")
    args = parser.parse_args()

    process_sketch_files(args.input_folder, args.output_csv)
