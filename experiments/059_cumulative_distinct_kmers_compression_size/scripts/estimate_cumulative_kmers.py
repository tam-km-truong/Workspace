import subprocess
import os
import sys
import argparse
import tempfile

def get_cardinality(sketch):
    result = subprocess.run(["dashing", "card", "--presketched", sketch], 
                            capture_output=True, text=True, check=True)
    result = result.stdout.strip().split('\t')[-1]
    return float(result)

def union_sketch(bin_sketch, genome_sketch, output_sketch):
    subprocess.run(["dashing", "union", "-o", output_sketch, bin_sketch, genome_sketch],
                   check=True, stdout=subprocess.DEVNULL)
    

def count_distinct_kmers(input_file, output_file, tmp_dir=""):
    if tmp_dir == '' :
        tmp_dir = tempfile.mkdtemp()
    else:
        os.makedirs(tmp_dir, exist_ok=True)
    print(tmp_dir)
    current_sketch = os.path.join(tmp_dir, "current.hll")
    union_sketch_path = os.path.join(tmp_dir, "union.hll")

    with open(input_file) as f, open(output_file, 'w') as out:
        first_line = f.readline().strip()

        if not first_line:
            print("Error: input file must contain a sketch.", file=sys.stderr)
            sys.exit(1)

        subprocess.run(["cp", first_line, current_sketch], check=True)
        subprocess.run(["cp", first_line, union_sketch_path], check=True)
        count = get_cardinality(union_sketch_path)
        out.write(f"{count}\n")

        for line in f:
            sketch_path = line.strip()
            if not sketch_path:
                continue
            union_sketch(current_sketch, sketch_path, union_sketch_path)
            count = get_cardinality(union_sketch_path)
            out.write(f"{count}\n")
            subprocess.run(["mv", union_sketch_path, current_sketch], check=True)

def parse_args():
    parser = argparse.ArgumentParser(description="Compute cumulative distinct k-mer counts using Dashing sketches.")
    parser.add_argument("input", help="File containing list of .hll sketch paths (one per line)")
    parser.add_argument("output", help="Output file to store the cumulative k-mer counts")
    parser.add_argument("--tmp", default="", help="Temporary directory for intermediate sketches (default: tmp)")
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    count_distinct_kmers(args.input, args.output, args.tmp)