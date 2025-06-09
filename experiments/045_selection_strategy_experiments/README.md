Experiment goal:

To study the effect of different selection strategy

To learn about the characteristics of a good selection

tutorial:

1st step: see the jupyter notebook in jupyter folder

2nd step: prepend the paths to all refs and queries txt files

```bash
for f in experiments/045_selection_strategy_experiments/references/without_path/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/045_selection_strategy_experiments/references/with_path/$(basename $f .txt).txt --is_text; done
```

```bash
for f in experiments/045_selection_strategy_experiments/queries/without_path/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/045_selection_strategy_experiments/queries/with_path/$(basename $f .txt).txt --is_text; done
```

3rd step: run attotree for skeleton trees then postprocessing trees

```bash
for f in experiments/045_selection_strategy_experiments/references/with_path/*.txt; do attotree -L $f -o experiments/045_selection_strategy_experiments/skeleton_trees/nw_files/$(basename $f .txt).nw -t 10; done
```

```bash
for f in experiments/045_selection_strategy_experiments/skeleton_trees/nw_files/*.nw; do python python_scripts/postprocess_tree.py --standardize --midpoint-outgroup --ladderize --name-internals -l experiments/045_selection_strategy_experiments/skeleton_trees/leaf_orders/$(basename $f .nw).txt -n experiments/045_selection_strategy_experiments/skeleton_trees/other/$(basename $f .nw).node.txt $f experiments/045_selection_strategy_experiments/skeleton_trees/other/$(basename $f .nw).std.nw; done
```

3rd step bis: preprend path

```bash
for f in experiments/045_selection_strategy_experiments/skeleton_trees/leaf_orders/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/045_selection_strategy_experiments/skeleton_trees/leaf_orders_with_path/$(basename $f .txt).txt --is_text; done
```

4th step: mash sketch the references

```bash
for f in experiments/045_selection_strategy_experiments/skeleton_trees/leaf_orders_with_path/*.txt; do mash sketch -l $f -o experiments/045_selection_strategy_experiments/ref_mash_sketches/$(basename $f .txt) -p 12 -s 1000;done
```

5th step: compute mash distance of queries and references

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/045_selection_strategy_experiments/ref_mash_sketches/reference_25.msh experiments/045_selection_strategy_experiments/queries/with_path/query_25.txt -l -o experiments/045_selection_strategy_experiments/mash_distances/distance_25.csv -v -t 12
```

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/045_selection_strategy_experiments/ref_mash_sketches/reference_50.msh experiments/045_selection_strategy_experiments/queries/with_path/query_50.txt -l -o experiments/045_selection_strategy_experiments/mash_distances/distance_50.csv -v -t 12
```

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/045_selection_strategy_experiments/ref_mash_sketches/reference_75.msh experiments/045_selection_strategy_experiments/queries/with_path/query_75.txt -l -o experiments/045_selection_strategy_experiments/mash_distances/distance_75.csv -v -t 12
```

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/045_selection_strategy_experiments/ref_mash_sketches/reference_100.msh experiments/045_selection_strategy_experiments/queries/with_path/query_100.txt -l -o experiments/045_selection_strategy_experiments/mash_distances/distance_100.csv -v -t 12
```

6th step: run jupyter notebook for genomes assignment

7th step: prependpath for local and for cluster


local

```bash
for f in experiments/045_selection_strategy_experiments/first_reordering/without_path/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/045_selection_strategy_experiments/first_reordering/with_path/$(basename $f .txt).txt --is_text;done
```

cluster

```bash
for f in experiments/045_selection_strategy_experiments/first_reordering/cluster_path/*.txt; do sed -i '' 's|^|/projects/reall/tam/data/661k/uncompressed_fastas/|; s|$|.fa|' $f;done
```

7th step: split the order into batches of 4000

8th step: compress with the workflow on the cluster