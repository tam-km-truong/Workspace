This experiment aims to test the effect of number of references genomes on final compression size for a single species using phylogenetic placement based strategy

Commands:

Step 1: generate references and queries datasets from jupyter notebook (selection)

Step 2: prepend path

```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/references/without_path/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/046_selection_strategy_percentage_for_single_species/references/with_path/$(basename $f .txt).txt --is_text;done
```

```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/queries/without_path/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/$(basename $f .txt).txt --is_text;done
```

Step 3: run attotree then postprocess then prepend the path

```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/references/with_path/*.txt;do attotree -L $f -o experiments/046_selection_strategy_percentage_for_single_species/trees/nw/$(basename $f .txt).nw -t 12;done

[attotree] 2025-07-15 00:40:55 Attotree starting
[attotree] 2025-07-15 00:40:55 None
[attotree] 2025-07-15 00:40:55 /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpv_tgopil
[attotree] 2025-07-15 00:40:55 Creating a temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpv_tgopil
[attotree] 2025-07-15 00:40:55 Running Mash
[attotree] 2025-07-15 00:40:55 Shell command: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
Max p-value: 0
[attotree] 2025-07-15 00:41:15 Finished: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
[attotree] 2025-07-15 00:41:15 Running Quicktree
[attotree] 2025-07-15 00:41:15 Shell command: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:41:15 Finished: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:41:15 Postprocessing tree
[attotree] 2025-07-15 00:41:15 Deleting the temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpv_tgopil
[attotree] 2025-07-15 00:41:15 Attotree finished

real	0m20.150s
user	2m32.249s
sys	0m0.553s
[attotree] 2025-07-15 00:41:15 Attotree starting
[attotree] 2025-07-15 00:41:15 None
[attotree] 2025-07-15 00:41:15 /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpmdwu2hiq
[attotree] 2025-07-15 00:41:15 Creating a temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpmdwu2hiq
[attotree] 2025-07-15 00:41:15 Running Mash
[attotree] 2025-07-15 00:41:15 Shell command: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
Max p-value: 0
[attotree] 2025-07-15 00:42:43 Finished: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
[attotree] 2025-07-15 00:42:43 Running Quicktree
[attotree] 2025-07-15 00:42:43 Shell command: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:42:46 Finished: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:42:46 Postprocessing tree
[attotree] 2025-07-15 00:42:46 Deleting the temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpmdwu2hiq
[attotree] 2025-07-15 00:42:46 Attotree finished

real	1m30.408s
user	12m48.098s
sys	0m1.996s
[attotree] 2025-07-15 00:42:46 Attotree starting
[attotree] 2025-07-15 00:42:46 None
[attotree] 2025-07-15 00:42:46 /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpw38z2ps8
[attotree] 2025-07-15 00:42:46 Creating a temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpw38z2ps8
[attotree] 2025-07-15 00:42:46 Running Mash
[attotree] 2025-07-15 00:42:46 Shell command: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
Max p-value: 0
[attotree] 2025-07-15 00:46:07 Finished: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
[attotree] 2025-07-15 00:46:07 Running Quicktree
[attotree] 2025-07-15 00:46:07 Shell command: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:46:21 Finished: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:46:21 Postprocessing tree
[attotree] 2025-07-15 00:46:21 Deleting the temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpw38z2ps8
[attotree] 2025-07-15 00:46:21 Attotree finished

real	3m35.566s
user	30m42.915s
sys	0m4.331s
[attotree] 2025-07-15 00:46:21 Attotree starting
[attotree] 2025-07-15 00:46:21 None
[attotree] 2025-07-15 00:46:21 /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpwpl7m0dw
[attotree] 2025-07-15 00:46:21 Creating a temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpwpl7m0dw
[attotree] 2025-07-15 00:46:21 Running Mash
[attotree] 2025-07-15 00:46:21 Shell command: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
Max p-value: 0
[attotree] 2025-07-15 00:53:46 Finished: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
[attotree] 2025-07-15 00:53:47 Running Quicktree
[attotree] 2025-07-15 00:53:47 Shell command: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:54:43 Finished: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 00:54:43 Postprocessing tree
[attotree] 2025-07-15 00:54:43 Deleting the temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpwpl7m0dw
[attotree] 2025-07-15 00:54:43 Attotree finished

real	8m21.696s
user	71m16.815s
sys	0m6.533s
[attotree] 2025-07-15 00:54:43 Attotree starting
[attotree] 2025-07-15 00:54:43 None
[attotree] 2025-07-15 00:54:43 /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmphi_079ti
[attotree] 2025-07-15 00:54:43 Creating a temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmphi_079ti
[attotree] 2025-07-15 00:54:43 Running Mash
[attotree] 2025-07-15 00:54:43 Shell command: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
Max p-value: 0
[attotree] 2025-07-15 01:05:38 Finished: 'mash triangle -s 10000 -k 21 -p 10 -l /v...'
[attotree] 2025-07-15 01:05:38 Running Quicktree
[attotree] 2025-07-15 01:05:38 Shell command: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 01:07:31 Finished: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-15 01:07:31 Postprocessing tree
[attotree] 2025-07-15 01:07:31 Deleting the temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmphi_079ti
[attotree] 2025-07-15 01:07:31 Attotree finished

real	12m47.814s
user	105m26.904s
sys	0m9.132s

```

```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/trees/nw/*.nw; do python python_scripts/postprocess_tree.py --standardize --midpoint-outgroup --ladderize --name-internals -l experiments/046_selection_strategy_percentage_for_single_species/trees/leaf_orders/without_path/$(basename $f .nw).txt -n experiments/046_selection_strategy_percentage_for_single_species/trees/others/$(basename $f .nw).node.txt $f experiments/046_selection_strategy_percentage_for_single_species/trees/others/$(basename $f .nw).std.nw;done
```

Step 4: mash sketch the references

```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/trees/leaf_orders/with_path/*.txt; do mash sketch -l $f -o experiments/046_selection_strategy_percentage_for_single_species/sketches/$(basename $f .txt) -p 12 -s 1000;done
```

Step 5: mash distance

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/046_selection_strategy_percentage_for_single_species/sketches/reference_01.msh experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_01.txt -l -o experiments/046_selection_strategy_percentage_for_single_species/distances/distance_01.csv -v -t 10
```

real	37m17.326s
user	287m31.622s
sys	88m8.752s

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/046_selection_strategy_percentage_for_single_species/sketches/reference_03.msh experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_03.txt -l -o experiments/046_selection_strategy_percentage_for_single_species/distances/distance_03.csv -v -t 10
```

real	47m30.222s
user	381m41.591s
sys	99m41.675s

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/046_selection_strategy_percentage_for_single_species/sketches/reference_05.msh experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_05.txt -l -o experiments/046_selection_strategy_percentage_for_single_species/distances/distance_05.csv -v -t 10
```

real	61m59.943s
user	487m28.435s
sys	131m12.481s

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/046_selection_strategy_percentage_for_single_species/sketches/reference_08.msh experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_08.txt -l -o experiments/046_selection_strategy_percentage_for_single_species/distances/distance_08.csv -v -t 10
```

real	75m58.633s
user	626m3.601s
sys	148m50.530s

```bash
python experiments/034_phylogenetic_placements/compute_distance_matrix.py experiments/046_selection_strategy_percentage_for_single_species/sketches/reference_10.msh experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_10.txt -l -o experiments/046_selection_strategy_percentage_for_single_species/distances/distance_10.csv -v -t 10
```

real	81m43.910s
user	701m17.401s
sys	166m43.708s

Step 6: run jupyter notebook for genomes assignment

Step 7: prependpath for local and for cluster, split into 4000

local

```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/first_reorder/without_path/*.txt; do python python_scripts/find_genome_paths.py $f ~/data/661k/gziped_full/ experiments/046_selection_strategy_percentage_for_single_species/first_reorder/with_path/$(basename $f .txt).txt --is_text;done
```

genouest - copy from without path first
```bash
for f in experiments/046_selection_strategy_percentage_for_single_species/first_reorder/genouest_path/*.txt; do sed -i '' 's|^|/projects/reall/tam/data/661k/uncompressed_fastas/|; s|$|.fa|' $f;done
```

split for all

```bash
gsplit -l 4000 -d -a 2 --additional-suffix=.txt experiments/046_selection_strategy_percentage_for_single_species/first_reorder/genouest_path/first_order_01.txt experiments/046_selection_strategy_percentage_for_single_species/batches/genouest_batches/batch_01__
```

8th step: compress with the workflow on the cluster