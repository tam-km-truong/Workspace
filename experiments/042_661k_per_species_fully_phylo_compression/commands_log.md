attotree

```bash
attotree -L {input} -o {output} -t 10
```

next, preprend path to genomes (this is done based on your preferences, i have a script for it)

```bash
python python_scripts/find_genome_paths.py experiments/042_661k_per_species_fully_phylo_compression/species_clusters/dustbins.txt ~/data/661k/gziped_full/ experiments/042_661k_per_species_fully_phylo_compression/species_clusters_with_path/dustbins.txt --is_text
```

```bash
for p in experiments/042_661k_per_species_fully_phylo_compression/species_clusters/fewer_than_10k/*.txt; do python python_scripts/find_genome_paths.py "$p" ~/data/661k/gziped_full/ experiments/042_661k_per_species_fully_phylo_compression/species_clusters_with_path/fewer_than_10k/"$(basename "$p" .txt)".txt --is_text;done
```

run this snakemake pipeline without enable_compression on the cluster to calculate attotree

```bash
snakemake --snakefile workflow/Snakefile --config input_dir=/projects/reall/tam/data/661k/species_clusters/fewer_than_10k/ output_dir=/projects/reall/tam/data/661k/species_clusters/misc/ enable_compression=False --cores 50
```