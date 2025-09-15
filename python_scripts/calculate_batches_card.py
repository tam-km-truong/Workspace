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

def merge_sketches(sketches, max_per_call=500):
    """
    Merge multiple HLL sketches into a single sketch using `dashing union`,
    splitting into chunks if too many arguments.
    """
    if len(sketches) == 1:
        return sketches[0]

    def _run_union(sketch_list):
        merged = tempfile.NamedTemporaryFile(suffix=".hll", delete=False).name
        cmd = ["dashing", "union", "-o", merged] + sketch_list
        subprocess.run(cmd, check=True)
        return merged

    if len(sketches) <= max_per_call:
        return _run_union(sketches)

    # Split into chunks and merge recursively
    intermediates = []
    for i in range(0, len(sketches), max_per_call):
        intermediates.append(_run_union(sketches[i:i + max_per_call]))

    return merge_sketches(intermediates, max_per_call)

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
