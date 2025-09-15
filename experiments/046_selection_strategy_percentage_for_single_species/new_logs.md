mash sketch -l experiments/027_mash_test/query_ecoli_path.txt -o experiments/027_mash_test/query_ecoli_sketch_1 -s 1000 -p 10
real	23m30.397s
user	171m54.499s
sys	0m55.722s

+

real	0m13.473s
user	1m40.096s
sys	0m0.554s

time mash sketch -l experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_03.txt -o experiments/046_selection_strategy_percentage_for_single_species/queries_sketches/qu03 -s 1000 -p 10

real	22m55.450s
user	168m33.550s
sys	0m54.001s

time mash sketch -l experiments/046_selection_strategy_percentage_for_single_species/queries/with_path/query_05.txt -o experiments/046_selection_strategy_percentage_for_single_species/queries_sketches/qu05 -s 1000 -p 10

real	22m40.463s
user	166m58.127s
sys	0m44.981s

ref 01 01
real	3m52.717s
user	38m21.771s
sys	0m11.111s

ref 03 qu 03

real	12m1.591s
user	119m14.054s
sys	0m23.121s

ref 05 q 05

real	18m9.738s
user	183m49.630s
sys	0m18.026s

ref 08 q 08

real	28m52.219s
user	292m25.576s
sys	0m33.475s

ref 10

real	35m17.694s
user	356m7.441s
sys	0m58.519s