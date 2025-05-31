sketching

```bash
for p in experiments/041_salmonella_enterica_phylo_order/parts/*.txt; do mash sketch -l "$p" -o experiments/041_salmonella_enterica_phylo_order/"$(basename "$p" .txt)" -p 12 -s 1000; done
```

compute distances

```bash
for p in experiments/041_salmonella_enterica_phylo_order/sketches/*.msh; do
python experiments/034_phylogenetic_placements/compute_distance_matrix.py "$p" experiments/041_salmonella_enterica_phylo_order/queries.txt -l -o experiments/041_salmonella_enterica_phylo_order/distances/distance."$(basename "$p" .msh)".csv -v -t 12; done
```

get min values and min leave name of each genomes

```bash
for p in experiments/041_salmonella_enterica_phylo_order/distances/*.csv; do python experiments/041_salmonella_enterica_phylo_order/get_min.py --input $p --output experiments/041_salmonella_enterica_phylo_order/min_values/"$(basename "$p" .csv)".txt --mode values;done
```

```bash
for p in experiments/041_salmonella_enterica_phylo_order/distances/*.csv; do python experiments/041_salmonella_enterica_phylo_order/get_min.py --input $p --output experiments/041_salmonella_enterica_phylo_order/min_names/"$(basename "$p" .csv)".txt --mode names;done
```

map and post processing using postprocessing.ipynb