#!/usr/bin/env python3

import os
import argparse
import sys
import subprocess
from typing import List, Optional, TextIO
# from concurrent.futures import ProcessPoolExecutor, as_completed
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

def run_cli(
        command: List[str],
        output_fn: Optional[str] = None,
        output_fo: Optional[TextIO] = None,
        err_msg: Optional[str] = None,
        raise_exception: bool = True,
        silent: bool = False,
        verbose: bool = True,
        capture_output: bool = False,
) -> Optional[str]:
    """
    Args:
        command (list): Shell command as a list of strings.
        output_fn (str, optional): Redirect stdout to a file.
        output_fo (file object, optional): Redirect stdout to a file object.
        err_msg (str, optional): Message to print on error.
        raise_exception (bool): Raise an exception if command fails.
        silent (bool): Suppress info messages.
        verbose (bool): Show full command instead of shortened.
    """    

    if output_fo and output_fn:
        raise ValueError("Provide only one of output_fo or output_fn")
    
    # format command for display
    command_concat = " ".join(f'"{arg}"' if " " in arg else arg for arg in command)

    if not silent and verbose:
        print(f"Running: {command_concat}")
    
    # handle output destination
    stdout_target = None
    if capture_output:
        stdout_target = subprocess.PIPE
    elif output_fn:
        try:
            stdout_target = open(output_fn, "w")
        except OSError as e:
            print(f"Error while opening output file: {e}", file=sys.stderr)
            if raise_exception:
                raise
            else:
                sys.exit(1)
    elif output_fo:
        stdout_target = output_fo
    else:
        # print to screen
        stdout_target = sys.stdout


    # run the command
    try:
        result = subprocess.run(
            command,
            stdout=stdout_target,
            stderr=subprocess.PIPE,
            universal_newlines=True
        )
    except Exception as e:
        print(f"Running command failed: {e}", file=sys.stderr)
        if raise_exception:
            raise
        else:
            sys.exit(1)
    finally:
        if output_fn and stdout_target is not None:
            stdout_target.close()

    # handling the result
    if result.returncode == 0 or result.returncode == 141:
        if not silent:
            print("Finished successfully")
    else:
        print(f'Failed with exit code: {result.returncode}', file=sys.stderr)
        if result.stderr:
            print(f"stderr: {result.stderr.strip()}", file=sys.stderr)
        if err_msg:
            print(f"Error: {err_msg}", file=sys.stderr)

        if raise_exception:
            raise RuntimeError("Shell command failed.")
        else:
            sys.exit(1)
    
    return result.stdout.strip() if capture_output else None

def mash_info_ref_id(reference_msh: str, delimiter: str) -> str:
    pipe = f"mash info {reference_msh} -t | cut -f3 | xargs -n1 basename | sed 's/\..*//' | paste -sd ' ' - | tr ' ' '{delimiter}'"
    ref_id = run_cli(["bash","-c", pipe,], capture_output=True, silent=True)
    return ref_id[2:]

def run_mash_distance_on_reference_list(reference_msh: str, query_file: str, delimiter: str) -> str:
    """
    Run mash dist reference.txt.msh genome.fa | cut -f3 | paste -sd ' ' - | tr ' ' ','  
    Return: <basename>,<distances>

    Example:
        Input: query_file = "path/to/sam0123.fa.gz"
        Output: "sam0123,0.23,0.21,0.01"
    """    
    # get base name
    basename = os.path.basename(query_file)
    name = basename.split('.')[0]
    pipe = f"mash dist {reference_msh} {query_file} | cut -f3 | paste -sd ' ' - | tr ' ' '{delimiter}'"
    distances = run_cli(["bash","-c", pipe,], capture_output=True, silent=True)
    return f"{name}{delimiter}{distances}"

def is_valid_result(result: str, min_fields: int = 2, preview_len: int = 100) -> bool:
    preview = result.strip()[:preview_len]
    parts = preview.split(',')
    return len(parts) >= min_fields and all(p.strip() for p in parts[:min_fields])

def parse_args():
    parser = argparse.ArgumentParser(
        description="Description of what your script does."
    )
    parser.add_argument(
        "reference",
        help="Path to the mash reference file"
    )
    parser.add_argument(
        "input",
        help="Path to the genome file or fof if -l"
    )
    parser.add_argument(
        "-o", "--output",
        help="Path to the output file (optional)",
        default=None
    )
    parser.add_argument(
        "-v", "--verbose",
        help="Enable verbose output",
        action="store_true"
    )
    parser.add_argument(
        "-l", "--list",
        help="Input is a file of file",
        action="store_true"
    )

    parser.add_argument(
        "-t", "--thread",
        type=int,
        help="Number of thread allowed",
        default= 1
    )

    parser.add_argument(
        "-d", "--delimiter",
        help="delimiter use",
        default= ','
    )

    parser.add_argument(
        "--invalid_paths",
        help="File to log invalid paths (default: invalid_paths.txt)",
        default="invalid_paths.txt"
    )

    return parser.parse_args()

def main():
    args = parse_args()

    output_stream = open(args.output, "w") if args.output else sys.stdout
    invalid_paths_file = open(args.invalid_paths, "a")

    if args.verbose:
        print(f"Reading from {args.input}")
        if args.output:
            print(f"Writing to {args.output}")

    try:
        print(mash_info_ref_id(args.reference, args.delimiter), file=output_stream)

        if args.list:
            # Input is a file containing multiple paths to genome files
            if not os.path.isfile(args.input):
                raise FileNotFoundError(f"File of files not found: {args.input}")
            print('Computing mash distances')

            # === OLD VERSION (read all lines into memory) ===
            # This version loads the entire file into memory at once.
            # May be problematic for very large input files.
            #
            # with open(args.input) as f:
            #     genome_paths = [line.strip() for line in f if line.strip()]
            # total = len(genome_paths)
            # with ProcessPoolExecutor(max_workers=args.thread) as executor:
            #     future_to_path = {
            #         executor.submit(
            #             run_mash_distance_on_reference_list, args.reference, path, args.delimiter
            #         ): path for path in genome_paths
            #     }
            #     for i, future in enumerate(as_completed(future_to_path), 1):
            #         genome_path = future_to_path[future]
            #         genome_name = os.path.basename(genome_path).split('.')
            #         genome_name = f"{genome_name[0]}.{genome_name[1]}"
            #         print(f"{i}/{total}: {genome_name}")
            #         try:
            #             result = future.result()
            #             output_stream.write(result + "\n")
            #         except Exception as e:
            #             print(f"Error {e}", file=sys.stderr)


            max_pending = args.thread
            futures = {}
            counting = 1 
            with ThreadPoolExecutor(max_workers=args.thread) as executor:
                with open(args.input) as f:
                    for line in f:
                        path = line.strip()
                        if not path:
                            continue
                        if not os.path.isfile(path):
                            print(f"Invalid path (not found): {path}", file=invalid_paths_file)
                            invalid_paths_file.flush()
                            continue                        
                        genome_name = Path(path).stem
                        print(f"Submitting job {counting} for: {genome_name}")
                        counting +=1
                        future = executor.submit(run_mash_distance_on_reference_list, args.reference, path, args.delimiter)
                        futures[future] = path

                        while len(futures) >= max_pending:
                            # print("Job queue full")
                            done_future = next(as_completed(futures))
                            done_path = futures.pop(done_future)
                            try:
                                result = done_future.result()
                                if is_valid_result(result):
                                    print(result, file=output_stream)
                                    if args.verbose:
                                        print(f"Completed job for: {Path(done_path).stem}")
                                else:
                                    # Invalid result: write path to invalid_paths.txt instead of retrying
                                    if args.verbose:
                                        print(f"Invalid result for {Path(done_path).stem}, logging invalid path.")
                                    print(done_path, file=invalid_paths_file)
                                    invalid_paths_file.flush()
                            except Exception as e:
                                print(f"Error processing {done_path}: {e}", file=sys.stderr)

                for future in as_completed(futures):
                    path = futures[future]
                    try:
                        result = future.result()
                        if is_valid_result(result):
                            print(result, file=output_stream)
                            if args.verbose:
                                print(f"Completed job for: {Path(path).stem}")
                        else:
                            if args.verbose:
                                print(f"Invalid result for {Path(path).stem}, logging invalid path.")
                            print(path, file=invalid_paths_file)
                            invalid_paths_file.flush()
                    except Exception as e:
                        print(f"Error processing {path}: {e}", file=sys.stderr)
        else:
            result = run_mash_distance_on_reference_list(args.reference, args.input, args.delimiter)
            if is_valid_result(result):
                print(result, file=output_stream)
            else:
                    print(args.input, file=invalid_paths_file)
                    invalid_paths_file.flush()
    finally:
        if args.output:
            output_stream.close()

if __name__ == "__main__":
    main()
