import subprocess
import os
import sys

def get_cardinality(sketch):
    result = subprocess.run(["dashing", "card", "--presketched", sketch], 
                            capture_output=True, text=True, check=True)
    result = result.stdout.strip().split('\t')[-1]
    return float(result)

def union_sketch(bin_sketch, genome_sketch, output_sketch):
    subprocess.run(["dashing", "union", "-o", output_sketch, bin_sketch, genome_sketch],
                   check=True, stdout=subprocess.DEVNULL)

def extract_genome_name(filepath):
    filename = os.path.basename(filepath)
    parts = filename.split(".")
    for part in parts:
        if part not in ["fa", "fq", "gz", "w", "31", "spacing", "10", "hll"]:
            return part
    return filename

def firstfit_hyperloglog(bin_capacity, sketch_files, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    tmp_dir = os.path.join(output_folder, "tmp")
    os.makedirs(tmp_dir, exist_ok=True)
    genome_sketches = sketch_files

    bin_result = []
    bin_paths = []
    bin_cardinalities = []
    bin_available = []

    if not genome_sketches:
        return bin_result, bin_cardinalities

    first_sketch = genome_sketches[0]
    genome_name = extract_genome_name(first_sketch)
    bin_result.append([genome_name])
    bin_0_path = os.path.join(tmp_dir, "bin_0.hll")
    subprocess.run(["cp", first_sketch, bin_0_path], check=True)
    bin_paths.append(bin_0_path)
    bin_available.append(True)
    initial_cardinality = get_cardinality(bin_0_path)
    bin_cardinalities.append(initial_cardinality)

    for genome_sketch in genome_sketches[1:]:
        genome_name = extract_genome_name(genome_sketch)
        placed = False
        print("Binning", genome_name)

        for i, bin_path in enumerate(bin_paths):
            if bin_available[i]:
                temp_union_path = os.path.join(tmp_dir, "temp_bin.hll")
                union_sketch(bin_path, genome_sketch, temp_union_path)
                union_card = get_cardinality(temp_union_path)

                if union_card <= bin_capacity:
                    subprocess.run(["mv", temp_union_path, bin_path], check=True)
                    bin_result[i].append(genome_name)
                    bin_cardinalities[i] = union_card
                    if union_card >= 0.95 * bin_capacity:
                        bin_available[i] = False
                    placed = True
                    break

        if not placed:
            new_bin_index = len(bin_result)
            new_bin_path = os.path.join(tmp_dir, f"bin_{new_bin_index}.hll")
            subprocess.run(["cp", genome_sketch, new_bin_path], check=True)
            bin_result.append([genome_name])
            bin_paths.append(new_bin_path)
            bin_available.append(True)
            new_cardinality = get_cardinality(new_bin_path)
            bin_cardinalities.append(new_cardinality)

    return bin_result, bin_cardinalities


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python bin_hll.py <threshold> <hll_list.txt> <output_folder>")
        sys.exit(1)

    bin_capacity = float(sys.argv[1])
    hll_list_file = sys.argv[2]
    output_folder = sys.argv[3]

    # Read .hll files from input list
    with open(hll_list_file) as f:
        sketch_files = [line.strip() for line in f if line.strip()]

    bins, cardinalities = firstfit_hyperloglog(bin_capacity, sketch_files, output_folder)

    # Save bin assignments
    # with open(os.path.join(output_folder, "bin_assignment.txt"), "w") as f:
    #     for i, (bin_content, bin_card) in enumerate(zip(bins, cardinalities)):
    #         f.write(f"Bin {i}: {', '.join(bin_content)}; Cardinality: {bin_card}\n")
    # Write each bin's genome names to output/bin/bin_{i}.txt
    bin_dir = os.path.join(output_folder, "bins")
    os.makedirs(bin_dir, exist_ok=True)
    for i, bin_content in enumerate(bins):
        with open(os.path.join(bin_dir, f"batch_{i}.txt"), "w") as bf:
            for genome in bin_content:
                bf.write(f"{genome}\n")