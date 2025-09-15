[attotree] 2025-07-11 15:49:04 Attotree starting
[attotree] 2025-07-11 15:49:04 None
[attotree] 2025-07-11 15:49:04 /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpllmc9o34
[attotree] 2025-07-11 15:49:04 Creating a temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpllmc9o34
[attotree] 2025-07-11 15:49:04 Running Mash
[attotree] 2025-07-11 15:49:04 Shell command: 'mash triangle -s 10000 -k 21 -p 5 -l /va...'
Max p-value: 1
[attotree] 2025-07-11 16:22:09 Finished: 'mash triangle -s 10000 -k 21 -p 5 -l /va...'
[attotree] 2025-07-11 16:22:10 Running Quicktree
[attotree] 2025-07-11 16:22:10 Shell command: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-11 16:27:44 Finished: 'quicktree -in m /var/folders/wc/cwdkw_2j...'
[attotree] 2025-07-11 16:27:44 Postprocessing tree
[attotree] 2025-07-11 16:27:44 Deleting the temporary directory /var/folders/wc/cwdkw_2j08vd3c_wq6wzy68jjjljpb/T/tmpllmc9o34
[attotree] 2025-07-11 16:27:44 Attotree finished


[2025-07-11T14:32:34Z INFO  miniphy2::commands::compress] Compressing TAR stream (xz -9, single thread).
[2025-07-11T14:32:34Z INFO  miniphy2::commands::compress] File 1/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__09/SAMN02908566.fa.gz'
[2025-07-11T14:32:36Z INFO  miniphy2::commands::compress] File 2/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__18/SAMN05660420.fa.gz'
[2025-07-11T14:32:38Z INFO  miniphy2::commands::compress] File 3/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__01/SAMD00016544.fa.gz'
[2025-07-11T14:32:41Z INFO  miniphy2::commands::compress] File 4/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__09/SAMN02908607.fa.gz'
[2025-07-11T14:32:45Z INFO  miniphy2::commands::compress] File 5/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__09/SAMN02908659.fa.gz'
...
...
...
[2025-07-11T23:46:55Z INFO  miniphy2::commands::compress] File 12497/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__33/SAMN08579792.fa.gz'
[2025-07-11T23:46:57Z INFO  miniphy2::commands::compress] File 12498/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__17/SAMN04993640.fa.gz'
[2025-07-11T23:47:00Z INFO  miniphy2::commands::compress] File 12499/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__46/SAMN10397391.fa.gz'
[2025-07-11T23:47:02Z INFO  miniphy2::commands::compress] File 12500/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__34/SAMN08815132.fa.gz'
[2025-07-11T23:47:04Z INFO  miniphy2::commands::compress] TAR archive created: 12500 files, 56.3 GiB after reformatting
[2025-07-11T23:47:04Z INFO  miniphy2::commands::compress] Compression completed: 56.3 GiB => 275.8 MiB (ratio: 208.92x).
[2025-07-11T23:47:04Z INFO  miniphy2::commands::compress] Process completed successfully.
Finished job 1.
4 of 5 steps (80%) done

localrule all:
    input: /Users/ktruong/workspace/Workspace/experiments/052_experiment_with_Alix/compression_results/fof_tam.path.tar.xz
    jobid: 0

Finished job 0.
5 of 5 steps (100%) done
Complete log: /Users/ktruong/tools/miniphy2_dev/.snakemake/log/2025-07-11T154904.791904.snakemake.log

VP-tree

sketching

real	33m36.725s
user	23m58.018s
sys	1m12.978s

Build VPTree ... 2.51e+03s
Build path ...
12500 / 12500
Time spent for path computation: 5.87e+04s

Computed distances (VPTree): 2321362/78118750
TSP total running time: 6.12e+04s

real	1020m27.049s
user	304m30.173s
sys	229m50.263s

[2025-07-13T13:20:13Z INFO  miniphy2::commands::compress] Compressing TAR stream (xz -9, single thread).
[2025-07-13T13:20:13Z INFO  miniphy2::commands::compress] File 1/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__18/SAMN05660420.fa.gz'
[2025-07-13T13:20:14Z INFO  miniphy2::commands::compress] File 2/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__01/SAMD00016544.fa.gz'
[2025-07-13T13:20:16Z INFO  miniphy2::commands::compress] File 3/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__07/SAMN02344908.fa.gz'
...
...
[2025-07-13T23:07:50Z INFO  miniphy2::commands::compress] File 12499/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__06/SAMN01779556.fa.gz'
[2025-07-13T23:07:55Z INFO  miniphy2::commands::compress] File 12500/12500: '/Users/ktruong/data/661k/gziped_full/salmonella_enterica__04/SAMEA2821536.fa.gz'
[2025-07-13T23:07:57Z INFO  miniphy2::commands::compress] TAR archive created: 12500 files, 56.3 GiB after reformatting
[2025-07-13T23:07:57Z INFO  miniphy2::commands::compress] Compression completed: 56.3 GiB => 278.8 MiB (ratio: 206.64x).
[2025-07-13T23:07:57Z INFO  miniphy2::commands::compress] Process completed successfully.
Finished job 1.
1 of 2 steps (50%) done

localrule all:
    input: /Users/ktruong/workspace/Workspace/experiments/052_experiment_with_Alix/compression_results/vp_tree_order.tar.xz
    jobid: 0

Finished job 0.
2 of 2 steps (100%) done
