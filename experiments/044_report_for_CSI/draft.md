1. Introduction (general context, goal of the PhD thesis)

    What is the broader scientific or technological challenge your thesis is addressing?
    
    - Genomic data are growing at a breaknect pace, within several year from 2019 with the 661k collection by Blackwell and al, to recently, November 2024, with the latest version of the AlltheBacteria collection with now at 2.4 milions genomes. In the future, we can expect the that the collections will be larger, with more species included (higher diversity), and the bioinformatics community is moving into the direction of metagenomic
    - This fast growing rate of genomic data leads to the need of new algorithm and techniques, as well as better tools and infrastucture to collect, store, analyse the ever growing database.

    Why is genome collection management (e.g., compression, indexing, retrieval) an important and timely problem?

    - As stated by Blackwell & al (2019), bacterial genomes uploaded to the public database at a faster and faster rate, but there isn't any common pipeline and parameters, lead to the fact that the genomes data are usually unsuitable for extensive analysis. Bacterial genomes collections solved this problem by download all the genomes from the database, unify the processing pipeline, filter out bad data. In the end resulted in a collection that are uniformly standard and can be analyse.

    - These collections are growing rapidly in volume, the 661k collection uncompressed is 800GB, allTheBacteria collection is almost 4TB. Which is problematique when storing and sharing those data at scale. Recently, Karel Brinda proposed phylogenetic collection (2025, Nature method) as a framework to adressed this problem. With phylogenetic compression, The 661k collection can be compressed down to just under 30GB using a general compressor such as xz. The same framework when applied to AllTheBacteria collection, reduce the size to just over 100GB.

    - Phylogenetic compression currently comprises of 2 key steps: split the entire genomes collections into smaller subset called batches, then for each batch, infere a phylogenetic tree, then reorder the genomes in the batch with using the order from the tree leaves.

    - The batching process comprises of several steps as well: first we split the genomes into clusters of species. The clusters of species that are highly sampled are then split into batches of 4000 genomes, the sparsely sampled species will be grouped into batches called dustbins of 1000 genomes.

    What are the fundamental limitations of current approaches (e.g., scalability, species bias, redundancy)?

    - Eventhough the current technique is already quite efficient at compression bacterial collections, phylogenetic compression requires species information to cluster the genomes together first. This taxonomy information may not be available all the time. Secondly, from the cluster of the species received from the taxonomy metadata, phylogenetic compression cut them into batches of 4000, which can be unflexible for different use cases (for example, we might want to have smaller number of genomes per batch when we want to reliably share the data through unstable network since smaller batch will have small size), futhermore, when we want to maximize the compression ratio, putting more similar genomes into 1 batch will increase the compression ratio of each batch.

    What is the central research question of your PhD? How does it relate to real-world needs (e.g., NCBI-scale datasets)?
    
    - My research question center around an efficient way of batching for phylogenetic compression. The biggest question is there a way of batching the genomes collections at scale to improve compression ratio, for different use cases and without taxonomy information.

    What is your main hypothesis? (e.g., that better genome ordering leads to better compression or indexing)

    - currently my main hypothesises are: distinct kmers count can be used to approximate post compression size of the batches. Bin packing optimization problem can be used to create batches of similar distinct kmers count. And finally using a naive version of phylogenetic placement can remove the need of using species information (taxonomy independent)

    How does your work build on or deviate from prior work (cite only if necessary)?

    - this work build on phylogenetic compression by Karel Brinda (2025)

    - this work also used extensively 661k collection and AllTheBacteria collection for experiments

    - mash, using minhash sketching to estimate genomes distances

    - dashing, using hyperloglog sketching to estimate distinct kmers count

    - BakRep is used for metadata exploration for 661k collection

    What will be the key contribution of your thesis if successful?

    - if successful, this work can be used for any bacterial assemblies collection, can compress data without any prior information of taxonomy

2. Main Track – Batching Optimization

    What batching problem are you solving, precisely? Be clear on the input, desired output, and constraints.

    - I'm solving what is called a bin packing problem, the input is a collection of genomes, and a user defined threshold, the output is the genomes assignment for each batches. Some constraints we could have is the number of genomes per batch, the species of the batches,...

    Why is batching a key step? How does it affect downstream tasks (compression, indexing, search, etc.)?
    
    - batching is an important step because firstly, we want to group genomes that are similar together to ensure a good compressibility, secondly, batching allows us to parralleize (for the compression step and as well as for different downstream analysis), analysis such as seach within the batches, index it, sharing the batches through the internet

    What batching strategies have you explored? How are they defined, implemented, and compared?

    - i have explored 2 bin packing strategies, the first is first fit bin packing, which preserves the order of the genomes collection, 2 strategy balance the distinct kmers count by distributing the genomes into differences batches, we then lost the order of the genomes. 

    - this is implemented in 2 snakemake workflow and scripts, call HLL-binning and HLL-balancing. The first fit bin packing is generally better in term of compression ratio, and the HLL-balancing is better at produce a balanced post compression size batches.

    What are the measurable effects of batching on compression (xz, etc.)? On other metrics (e.g., runtime, memory, deduplication)?

    - the biggest measurable effects would be compression ratio, the more similar genomes we can put together in a batch, the better the comperssion ratio could be, but this strategy could lead to a very high compression time, this long compression time is due to unable to paralellization for 1 batches. we can paralel with multiple batches

    Did you find that some strategies are better for certain species or dataset types? Any unexpected patterns?
    - generally, there are no differences for different species or datasets

    How scalable is your method in terms of time/memory/runtime? Could it run on 100k genomes?

    - HLL binning is tested on the whole 661k collections on 661402 genomes, it finished in less than 12 hours with the current naive implementation

    What artifacts or tools have you produced (e.g., scripts, Snakemake workflows)? Are they reusable?

    - I have HLL-binning and HLL-balancing on my github

    Have you rebatched and recompressed any real-world collections? What did the results show?

    - I have rebatched and recompressed the 661k collection, currently running

3. Side Track – Experiments with Orders (incl. MiniPhy)

    What is the purpose of experimenting with genome orders?

    - experimenting with genomes orders to better understand its effects on compression ratio, as well as how predictable post compression size can be approximate using distinct kmers counts using a linear regression model for different genomes orders

    How do different orderings (random, accession, phylogenetic, hybrid) impact compression and other downstream tasks?

    - from my experiment, phylogenetic compression produce the best batches in term of compressibility

    What methods/tools did you use to compute these orders? How robust are they?

    - I used dashing to estimate distinct kmers count, pandas and r for data analyis

    How did MiniPhy perform in terms of speed, accuracy, utility for ordering? Did you compare it with other tools?

    - I also involved in the development of Miniphy2 the 2nd version of Miniphy, the tools for phylogenetic compression from Karel Brinda. Miniphy2 is developed in rust, it is better optimized and suitable for newer and larger collections

    What are the key takeaways from the experiments? Were there any surprises or inconsistencies?

    - The key take aways from this experiment is that we can approximate genomes batches compression sizes using distinct kmers count, but we also need species information and the order used to reorder the batches

    Do these orderings suggest directions for future batching or full-dataset processing?

    - the best order is phylogenetic order using mash distance and neighbor joining tree algorithm.

    - we want to approximate that order at scale, for millions of genomes, which can be a huge task since quicktree, the tool for neighbor joining algorithm has a compexility of O(n^3)

    Were any tools, results, or methods reused or repurposed from this track in the main track?
    
    - the tools and reulst and methods from this track is used extensively in conjunction with the main track

4. Conclusion / Outlook

    What is the state of your thesis right now? (what is done, what is partially done, what is still missing?)

    - the theis is currently approaching the first result using the new taxonomy independent strategy

    What are the strongest results you currently have?

    - the current most promising result is hll-binning taxonomy-independent phylogenetic compression of the 661k collection, but a lot of optimization still need to be done

    What is your current thinking about the final structure of your thesis? (how many chapters, what are they?)

    - the theis might consist of 2 big chapters, the 2 chapters are the 2 key steps of the new phylogenetic compression framework. First chapter would be taxonomy independent reordering of the entire collection (millions of genomes). 2nd chapter would be how to efficiently cut the new reorder collection into batches of similar genomes, for different usecases and with different constraints

    What are the major questions or uncertainties that still remain?

    - the biggest question now is still how scalable is the new approach. can we move away from using species information entierly. if provided species information, is it better than the original strategy.

    What are your next concrete steps (for the next 6 months)? What are the riskiest ones?

    - i want to finalize the first new framework, run more extensive experiment, extend the experiment to the AllTheBacteria collections, develop a new tool for this

    How will you validate or publish your findings? Are you aiming for software release, datasets, papers?

    - yes i'm aiming for a new software release, recompressed dataset on zenodo and the first paper submission in my first year of phd

    What would make this PhD a success in your eyes (beyond just “it worked”)?

    - this phd would be a success if i can help collaborator compress all kind of dataset and collections.