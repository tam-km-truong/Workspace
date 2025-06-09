Introduction

Genomic data are growing at a breakneck pace. In just a few years, the size of publicly available genome collections has increased dramatically. For example, the 661k bacterial genome collection published in 2019 by Blackwell et al. has been followed by the latest version of the AllTheBacteria collection, released in November 2024, which now includes over 2.4 million genomes. This impressive growth is expected to continue, both in volume and diversity, especially with the increasing interest in metagenomics and pan-genomics. Such rapid expansion poses major challenges. New tools, algorithms, infrastructure, and methods are needed to store, organize, and analyze these genomic collections efficiently at scale.

As noted by Blackwell et al. (2019), genomes are uploaded to public databases at an accelerating rate. However, there is no standardized pipeline for quality control, filtering, or preprocessing. As a result, genome datasets are often inconsistent and unsuitable for large-scale comprehensive analysis. This has led to the creation of curated collections such as the 661k and AllTheBacteria datasets, which address this issue by applying uniform processing and quality control. These benefits come at a cost: large file sizes. The uncompressed 661k collection is around 800 GB, and the latest AllTheBacteria dataset is nearly 4 TB, making storage, distribution, and analysis challenging.

A recent advance, phylogenetic compression (Brinda et al., 2025, Nature Methods), proposes a solution. It reduces the size of bacterial genome collections using evolutionary relationships between genomes. The genomes are divided into smaller batches, reordered phylogenetically, and then compressed using a general-purpose compressor such as xz. This method reduces the 661k collection to just under 30 GB and the AllTheBacteria collection to around 100 GB—an improvement of one to three orders of magnitude.

Despite these clear benefits, current phylogenetic compression methods have several key limitations:

    Dependence on taxonomy: The batching process relies on species-level taxonomic information to group genomes. However, taxonomy data are not always available or reliable.

    Rigid batching: Current batching rules (for example, a default of 4,000 genomes for well-sampled species and 1,000 for dustbins) are inflexible. Different use cases may require different batch sizes, and batch sizes should ideally vary depending on how compressible the genomes in a batch are. For example, in contexts requiring stable data sharing over unreliable networks, smaller batches may be preferable.

    Suboptimal compression ratio: In theory, grouping more similar genomes should lead to better results, but current methods may not always achieve this optimally.

My PhD focuses on the following question, motivated by the growing scale of bacterial data at public databases such as NCBI and the need for general-purpose, practical solutions that do not require predefined species metadata:

Is it possible to design an efficient, scalable, and taxonomy-independent method for batching bacterial genomes that improves compression while supporting multiple use cases?

The main working hypotheses are:

    Distinct k-mer counts can be used to approximate the post-compression size of genome batches.

    Bin-packing algorithms can be used to group genomes dynamically based on a distinct k-mer count threshold, rather than a fixed number of genomes per batch.

    A simple implementation of phylogenetic placement may allow taxonomy-free batching of genome collections.

This work builds directly on the phylogenetic compression framework proposed by Karel Brinda (2025). It uses public collections such as 661k and AllTheBacteria for experiments and benchmarks. Additionally, tools such as Mash and Dashing (sketching tools) are used extensively.

Principal Track: Batching Strategies for Bacterial Genome Collections

The first main track of the current work is batching optimization. Batching is one of the two key steps in phylogenetic compression. It is important for several reasons. First, grouping similar genomes together improves compressibility. Second, dividing the collection into batches facilitates parallel downstream analysis, scaling of indexing and search, and data sharing.

Batching in the current framework is constrained by multiple factors: an upper and lower bound on compressed size, an upper bound on decompressed size, an upper bound on the number of genomes per batch, and the goal of maximizing the compression ratio within these constraints.

These constraints naturally lead to a well-known and well-studied optimization problem: bin packing. In this context, genomes are treated as items with weights corresponding to biological features such as k-mer counts or estimates of compressibility based on measures like minimal string attractors or delta metrics.

I implemented two batching strategies using bin-packing heuristics and HyperLogLog sketching. HyperLogLog is used to estimate the number of distinct k-mers in genomes and genome sets. This estimated value serves as the capacity measure for each batch. The two heuristic algorithms are:

    First-fit binning: Processes genomes in a fixed order and adds each genome to the first batch that can accommodate it.

    Balancing binning: Distributes genomes across batches to balance the total number of distinct k-mers in each batch. This sacrifices the original genome order.

Both strategies are implemented as reusable Snakemake workflows, combining Bash and Python scripts. They are publicly available on GitHub. To evaluate the resulting batches, the primary metric is the compression ratio, alongside secondary metrics such as bits per k-mer or bytes per genome. Better batching (i.e. grouping more similar genomes) significantly reduces compressed size. However, overly large and diverse batches can lead to slower compression and even memory issues. Balanced batches also enable parallelism, speeding up the overall pipeline. HLL-based binning was tested on the full 661k collection and completed in under 12 hours using a naive sequential implementation. This time accounts only for the batching step.

Secondary Tracks: Taxonomy-Independent Recompression, Genome Order Experiments, Correlation Studies, and Development of Miniphy2

Several secondary tracks are also being studied.

The first explores the correlation between distinct k-mer counts and post-compression size under different genome orderings: random, accession-based, phylogenetic, and hybrid orders. These different orderings produce different levels of compression. Phylogenetic order consistently performs best, as it clusters similar genomes. In conclusion, the number of distinct k-mers is a good predictor of compression size, especially under consistent ordering schemes. However, to improve accuracy across species, both ordering and species labels are relevant. Phylogenetic ordering improves both compression and predictability of the outcomes.

While phylogenetic ordering is currently the best known strategy, building full trees on massive datasets is computationally expensive. One alternative is to use phylogenetic placement without relying on taxonomy. A subset of genomes (selected using a method such as random sampling or by accession range) is used to infer a skeleton tree. The remaining genomes are placed onto this tree by similarity. A second reordering step refines the local ordering within subgroups. This approach yields a taxonomy-independent heuristic phylogenetic order that can be used for batching.

Finally, I am involved in the development of Miniphy2, a Rust-based tool optimized for use on computing clusters. Miniphy2 supports massively parallel workflows. With it, we are able to recompress the 661k collection in less than 24 hours. The tool is more optimized, easier to use, and designed with scalability in mind.

Conclusion

The thesis is in an exploratory phase but is approaching its first complete results. I am finalizing a taxonomy-independent framework for compressing large genome collections and testing it on real-world datasets. The most promising result so far is the successful application of HLL-based binning combined with taxonomy-independent phylogenetic ordering on the 661k bacterial genome collection. This result demonstrates both feasibility and potential for further improvement.

The thesis will likely be structured into two main parts:

    Taxonomy-independent ordering of large genome collections, focusing on efficient and scalable strategies for computing phylogenetic orders.

    Batching of ordered genomes under user-defined constraints, covering practical bin-packing algorithms for use cases such as compression, indexing, data sharing, and deployment on different hardware architectures including GPUs and PIMs.

In the remaining time of my first year, I plan to:

    Run extended experiments on the AllTheBacteria dataset
    
    Finalize and document the new reordering and batching framework

    Develop a new tool to accompany Miniphy2

    Prepare a first software release and publish recompressed datasets (e.g. via Zenodo)

    Submit a first research paper

The most challenging task is scaling up the phylogenetic ordering algorithm to millions of genomes without relying on full tree reconstruction. Nevertheless, with this new framework and an improved understanding of how to compress large genome collections efficiently on the INRIA infrastructure, I hope our group will become a reliable partner for collaborators who wish to share and compress diverse genome collections without relying on predefined taxonomies.