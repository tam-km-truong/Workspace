import numpy as np
import argparse

def process_csv(input_csv_path, output_txt_path, mode):
    with open(input_csv_path, "r") as infile, open(output_txt_path, "w") as outfile:
        # Read and parse header (excluding index column)
        header = next(infile).strip().split(',')[1:]

        for line in infile:
            parts = line.strip().split(',')
            try:
                values = np.fromiter((float(x) for x in parts[1:]), dtype=np.float64)
                min_val = np.min(values)
                if mode == 'values':
                    outfile.write(f"{min_val}\n")
                elif mode == 'names':
                    min_indices = np.where(values == min_val)[0]
                    min_index = min_indices[-1]
                    min_col_name = header[min_index]
                    outfile.write(f"{min_col_name}\n")
            except Exception:
                outfile.write("NaN\n")  # Handle errors

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process a large CSV file to extract row-wise minimum values or column names.")
    parser.add_argument("--input", required=True, help="Input CSV file path")
    parser.add_argument("--output", required=True, help="Output TXT file path")
    parser.add_argument("--mode", required=True, choices=["values", "names"], help="Output mode: 'values' for min values, 'names' for column names")

    args = parser.parse_args()
    process_csv(args.input, args.output, args.mode)
