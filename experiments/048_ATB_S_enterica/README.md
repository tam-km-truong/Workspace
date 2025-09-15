python python_scripts/find_genome_paths.py experiments/048_ATB_S_enterica/remains_s_enterica.txt /Users/ktruong/data/AllTheBacteria/fasta_files/s_enterica/original_batches/ experiments/048_ATB_S_enterica/remains_s_enterica.path.txt --is_text


placement
real	1058m38.328s
user	8381m23.160s
sys	1685m56.372s

real	889m5.514s
user	8524m33.369s
sys	1625m8.189s


_____post processing

real	22m30.430s
user	20m57.310s
sys	0m27.391s

real	13m57.633s
user	11m49.388s
sys	0m32.919s

real	13m54.407s
user	11m50.939s
sys	0m28.348s

real	13m49.601s
user	11m52.151s
sys	0m31.428s


snakemake --snakefile workflow/Snakefile_no_tree --config input_dir=/projects/reall/tam/data/ATB_experiments/048_s_enterica_skeleton_strat/batches/subdir_1/ output_dir=/projects/reall/tam/data/ATB_experiments/048_s_enterica_skeleton_strat/compression_results/ --cores 40 --resource mem_mb=39000