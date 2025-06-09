1. Introduction
Broader scientific and technological context

Genomic data are growing at a breakneck pace. In just a few years, the size of publicly available genome collections has expanded dramatically — from the 661k bacterial genome collection published in 2019 by Blackwell et al. to the latest version of the AllTheBacteria collection in November 2024, which now includes over 2.4 million genomes. This exponential growth is expected to continue, both in volume and diversity, especially with increasing interest in metagenomics and pan-genomics.

This rapid expansion poses major challenges. Traditional tools and pipelines are struggling to keep up, creating a pressing need for new algorithms, infrastructure, and methods to store, organize, and analyze genomic collections efficiently at scale.
Why genome collection management is a timely and important problem

As highlighted by Blackwell et al. (2019), genomes are uploaded to public databases at an accelerating rate. However, there is no standardized pipeline for quality control, filtering, or annotation. As a result, genome datasets are often inconsistent and unsuitable for large-scale comparative analysis.

Community-curated collections like the 661k and AllTheBacteria collections address this by applying uniform preprocessing, quality filtering, and metadata unification, producing clean, analysis-ready datasets. But these collections come with a cost: enormous file sizes. The uncompressed 661k collection is over 800 GB, and the latest AllTheBacteria dataset is nearly 4 TB — making storage, distribution, and search highly inefficient.

A recent advance, phylogenetic compression (Brinda et al., 2025, Nature Methods), proposes a solution. It reduces genome collection size by exploiting evolutionary redundancy: genomes are split into smaller batches, reordered phylogenetically, and compressed using general-purpose compressors like xz. This method reduced the 661k collection to just under 30 GB and the AllTheBacteria dataset to slightly over 100 GB — a dramatic improvement.
Limitations of current methods

Despite their efficiency, current approaches have key limitations:

    Dependence on taxonomy: The batching process relies on species-level taxonomic information to group genomes. But taxonomy metadata is not always available or reliable, particularly in environmental or metagenomic contexts.

    Rigid batching: Current batching rules (e.g., fixed batch sizes of 4000 genomes for well-sampled species, and 1000 for "dustbins") lack flexibility. Different use cases may require different batch sizes — for instance, smaller batches for more robust data sharing in unstable networks.

    Compression suboptimality: The current approach doesn’t explicitly optimize for compression. In theory, grouping more similar genomes (e.g., based on k-mer content) could lead to better results.

Central research question

This PhD thesis focuses on the question:

    Can we design an efficient, scalable, and taxonomy-independent method for batching bacterial genomes that improves compression and supports multiple use cases?

This question is motivated by the growing scale of genome collections at institutions like NCBI and the need for general-purpose, practical solutions that are not tied to predefined species labels.
Main hypotheses

The main working hypotheses of this thesis are:

    Distinct k-mer counts can be used to approximate post-compression size of genome batches.

    Bin-packing algorithms can be used to group genomes with similar distinct k-mer profiles to form more compression-friendly batches.

    A simple form of phylogenetic placement may allow for taxonomy-free batching by placing genomes into an evolving collection without requiring labeled species information.

Relationship to prior work

This thesis builds directly on the phylogenetic compression framework proposed by Karel Brinda (2025), and it reuses key public collections such as 661k and AllTheBacteria as benchmarks.

Additionally, this work relies on tools like BakRep for metadata exploration and collection structure analysis.
Potential contributions

If successful, this thesis will provide:

    A general-purpose batching method that works without taxonomic metadata;

    A scalable and adaptable framework for compression-optimized genome batching;

    Reusable workflows and tools applicable to any large-scale collection of bacterial assemblies.

These contributions will enable more efficient sharing, archiving, and analysis of large bacterial genome collections in diverse scientific and clinical settings.

🔹 Broader scientific/technological challenge

Q1. How do you define the bottlenecks in current large-scale genome data analysis workflows?

    Is the primary issue storage, transfer, searchability, reproducibility, or something else?

    Do current workflows fail in accuracy, scalability, or both?

Q2. How is this problem different from, say, large-scale human genomics or transcriptomics?

    Why are bacterial genome collections particularly challenging?

    Are there properties (e.g., high redundancy, strain-level diversity) that you can exploit or must deal with?

Q3. What are the trends that make this problem urgent now?

    Growth rate of genome submissions?

    Increase in species diversity?

    Shift toward metagenomic or environmental sequencing?

👉 Refinement: Your opening could be stronger if it contextualized your work within these broader bottlenecks, not just data growth.
🔹 Importance of genome collection management

Q4. What happens if we don't solve this problem?

    Will data become unmanageable? Will important insights be delayed or missed?

    How does this affect downstream users (e.g., AMR surveillance, public health databases)?

Q5. Are there other solutions competing with phylogenetic compression?

    How do formats like CRAM, pangenome graphs, or de Bruijn graphs compare?

    Are they complementary or mutually exclusive?

Q6. Why is compression alone not enough?

    Is it about compressing more or compressing smarter?

    Do you aim to support other operations like fast querying or indexing?

👉 Refinement: You might elaborate more on the trade-off space — storage size vs. usability, compression ratio vs. flexibility, etc.
🔹 Limitations of current approaches

Q7. Why is taxonomy-based batching a bottleneck?

    Is taxonomy unavailable, unreliable, or just inflexible?

    Are there examples where taxonomic classification misleads batch assignment?

Q8. Is fixed batch size (e.g., 4000) a legacy design or a theoretically grounded choice?

    Would compression benefit from adaptive or content-aware batch sizing?

    Can you quantify the trade-off between batch size and compression performance?

Q9. How critical is inter-batch similarity vs. intra-batch similarity?

    Are we compressing each batch independently or jointly?

    Could this lead to suboptimal decisions if batch boundaries cut across very similar genomes?

Q10. Can phylogenetic trees be misleading or unstable due to poor input quality?

    If so, how robust is the current reordering strategy?

    Do small tree errors lead to big compression errors?

👉 Refinement: You could discuss not just what the limitations are, but how much they affect performance — use experimental hints if you have them.
🔹 Central research question

Q11. Is your goal to beat the current framework in compression ratio, generality, or usability?

    What’s your performance yardstick?

    Can your method scale to 10M genomes?

Q12. How generalizable is your batching method?

    Does it depend on input format, completeness of assemblies, or other preprocessing assumptions?

    Could it extend beyond bacteria (e.g., viruses, fungi)?

Q13. How does your work connect to broader infrastructure challenges (e.g., federated sharing, FAIR principles)?

    Could your work help enable new tools like remote search over compressed data?

👉 Refinement: Position your question more broadly — you are not just optimizing batches, but proposing a general framework for compressing massive genome sets without prior information.
🔹 Main hypotheses

Q14. Why do you believe distinct k-mer counts correlate with post-compression size?

    Can you show theoretical or empirical support?

    Are there known exceptions or caveats (e.g., repeats, GC bias)?

Q15. What does “similar distinct k-mer count” mean in terms of similarity?

    Are you assuming this reflects phylogenetic or functional proximity?

    Could two very different genomes have similar k-mer counts?

Q16. Why bin-packing? What are the objective functions and constraints?

    Do you minimize total volume, balance size, or maximize similarity?

    How sensitive is the method to the bin size or initialization?

Q17. What is your "naive phylogenetic placement"?

    Does it scale to millions of genomes?

    How does it compare to accurate but slow placement (e.g., maximum likelihood)?

👉 Refinement: Each hypothesis should be followed by a plan to test or falsify it. Add precision — how are these hypotheses operationalized in your pipeline?
🔹 Prior work: build or deviate

Q18. Where does your approach innovate over Brinda et al.?

    Are you generalizing their pipeline, removing dependencies, or improving heuristics?

Q19. What assumptions did prior work make that you are challenging or dropping?

    Is it taxonomic reliance, fixed batching, tree construction strategy, etc.?

Q20. How dependent is your work on curated datasets like 661k or AllTheBacteria?

    Can your ideas work on noisy, fragmented, or raw public data?

👉 Refinement: Make your contribution clearer by contrasting it head-to-head with the baseline.
🔹 Key contribution (if successful)

Q21. What concrete tools or outputs will your thesis produce?

    A software package? A benchmark dataset? A methodology for batching?

Q22. Who are the users of your contribution?

    Bioinformaticians? Data curators? Infrastructure engineers?

Q23. Could your methods help outside compression (e.g., search, deduplication, clustering)?

    Could it reduce computational load in pan-genome or AMR analysis?

Q24. What is your fallback plan if hypotheses fail?

    If distinct k-mers don’t work, is there a plan B?

👉 Refinement: Be honest about risk and payoff. What’s the minimal viable impact of your thesis? What would be the "ideal" impact?

🔹 2. Main Track – Batching Optimization (Draft Refinement + Critical Questions)
❖ What batching problem are you solving, precisely?

    I'm solving a bin packing problem. The input is a collection of genomes and a user-defined size threshold. The output is a set of batches, each containing a subset of genomes. The main constraint is that the total “volume” (estimated with HyperLogLog cardinality of distinct k-mers) of each batch should not exceed the threshold.

🧠 Critical additions/questions:

    Do you treat all genomes equally, or do they have “weights” (e.g. k-mer cardinality)?

    Is the goal to minimize the number of bins, balance their sizes, or maximize intra-batch similarity?

    Is batch size constrained by number of genomes, k-mers, or both?

👉 Clarify if the input includes genome metadata or if it's completely blind.
❖ Why is batching a key step?

    Batching is crucial for two reasons:

        Compression efficiency: grouping similar genomes together improves deduplication and dictionary reuse in compressors like xz.

        Parallelization: separate batches can be compressed and analyzed independently, enabling scalable indexing, search, and distribution.

🧠 Critical additions/questions:

    Can you quantify how much compression ratio varies with different batching strategies?

    What’s the cost of bad batching — 2x larger compressed size? 5x longer decompression?

    Does poor batching lead to redundant indexing/search effort?

👉 Could also mention data sharing and reproducibility (e.g., uploading batch archives to ENA/SRA).
❖ What batching strategies have you explored?

    I implemented two batching strategies:

        First-Fit HLL Binning: Processes genomes in a fixed order and adds each genome to the first batch that can accommodate its HLL-estimated k-mer count without exceeding the threshold.

        HLL Balancing: Sorts genomes by HLL size and distributes them across bins to balance total k-mer cardinality per bin. This sacrifices the original order but improves size balance.

🧠 Critical additions/questions:

    Why do you preserve order in one strategy but not the other?

    Do you expect any stability or fairness difference between the two?

    How is HLL computed (e.g., k=31, memory usage)? Do you precompute or compute on the fly?

👉 You could justify that First-Fit is closer to real-world streaming ingestion pipelines.
❖ How are they implemented and compared?

    Both strategies are implemented as reusable Snakemake workflows with Bash and Python scripts. They are publicly available on GitHub.

🧠 Critical additions/questions:

    Are the implementations modular? Could someone plug in a different binning heuristic?

    Did you profile the workflows for memory or runtime bottlenecks?

👉 Linking to GitHub in your manuscript/slides would be useful.
❖ What are the measurable effects of batching on compression (xz, etc.)?

    The primary metric is compression ratio. Better batching (more similar genomes in the same batch) significantly reduces compressed size. However, overly large batches with high diversity can cause slow compression or even memory issues. Balanced batches also enable parallelization, speeding up the overall pipeline.

🧠 Critical additions/questions:

    Have you quantified how batch diversity correlates with compression time or size?

    How do your results vary with different compressors (e.g., xz, zstd, gzip)?

    Could compression time be a proxy for genome diversity in a batch?

👉 This section could benefit from a small table or plot to compare strategies.
❖ Do some strategies work better for certain species or datasets?

    So far, we have not observed species-specific performance differences. The benefits of smart batching appear consistent across diverse bacterial clades.

🧠 Critical questions:

    Could this change with metagenomic or viral datasets?

    What about datasets with highly uneven genome sizes (e.g., some being 5x larger)?

👉 You might eventually discover exceptions worth reporting (e.g., clonal populations).
❖ How scalable is your method?

    HLL-based batching was tested on the full 661k collection (661,402 genomes) and completed in under 12 hours using a naive sequential implementation.

🧠 Critical additions/questions:

    What are the hardware specs used?

    Could it scale to 10 million genomes?

    Is memory usage per batch or per genome?

👉 Mention possible future improvements: multi-threading, streaming input, GPU HLL.
❖ What tools/artifacts have you produced?

    I developed two Snakemake workflows: HLL-binning and HLL-balancing, available on GitHub. They are modular, well-documented, and designed to be reused or extended.

🧠 Critical questions:

    Have they been tested on other datasets (besides 661k)?

    Do they accept different input formats or metadata?

👉 If your thesis includes tool development, include test cases, examples, and reproducibility features.
❖ Have you rebatched and recompressed real-world collections?

    Yes, I rebatched and recompressed the 661k bacterial genome collection. The experiments are still ongoing, but early results show that batching strategies significantly influence compression ratios and the distribution of compressed batch sizes.

🧠 Follow-up questions:

    What does the size distribution of compressed batches look like?

    Any surprising compression artifacts (e.g., bimodal sizes)?

    Did you compare rebatched results to the original batching in Brinda et al.?

👉 Once the run finishes, report: total size, average batch size, std dev, max/min, and compression time.

🔹 3. Side Track – Experiments with Genome Orders (including MiniPhy)
❖ What is the purpose of experimenting with genome orders?

    The goal is to understand how genome ordering affects compression efficiency and whether the post-compression size of batches can be reliably approximated using lightweight metrics, such as the number of distinct k-mers. In particular, I use linear regression models to estimate compressed sizes under different orderings.

❖ How do different orderings impact compression and downstream tasks?

    Different genome orders—random, accession-based, phylogenetic, and hybrid—lead to varying levels of compression performance. Among them, phylogenetic order consistently yields the best compression ratios by grouping similar genomes together.

❖ What methods/tools did you use to compute these orders? How robust are they?

    To compute these orderings:

        I used Dashing to estimate the number of distinct k-mers per genome (sketch-based estimation).

        I used MiniPhy2, a Rust-based reimplementation of the phylogenetic compression pipeline (originally by Karel Brinda), to generate phylogenetic orderings using Mash distances and neighbor-joining trees.

        Pandas and R were used for data analysis and regression modeling.

    These tools are efficient and scalable, but certain steps (e.g. tree construction via QuickTree) become computationally expensive at large scale (O(n³)).

❖ How did MiniPhy2 perform in terms of speed, accuracy, and utility?

    MiniPhy2 is significantly faster and more memory-efficient than its predecessor. It is optimized for large collections (hundreds of thousands to millions of genomes). While not benchmarked head-to-head with other tools yet, its integration and speed make it suitable for batch ordering in large-scale pipelines.

❖ What are the key takeaways? Any unexpected patterns or insights?

        The number of distinct k-mers can serve as a good predictor of compressed size, especially under consistent ordering schemes.

        However, to improve accuracy across species, both the genome order and species label information are important.

        Phylogenetic ordering improves not only compression but also predictability of compression outcomes.

        Surprisingly, accession-based order (common in public datasets) performs poorly in both compression and model accuracy.

❖ Do these orderings suggest future directions for batching or full-dataset processing?

    Yes. Phylogenetic ordering (based on sketching and tree reconstruction) is currently the best strategy for maximizing similarity within batches. However, constructing full trees on massive collections is computationally expensive. A key direction is to approximate phylogenetic order at scale using faster heuristics or low-resolution trees, possibly using streaming or hierarchical approaches.

❖ Were any tools, methods, or results from this track reused in the main track?

    Yes. The orderings and sketching tools (Dashing, MiniPhy2) are reused extensively in the main bin-packing experiments. The hybrid batching strategies (e.g., accession + phylogenetic) were built directly from the results of this track.

🔹 4. Conclusion / Outlook
❖ What is the current state of your thesis?

    The thesis is in an exploratory phase but approaching the first complete results. I am finalizing a taxonomy-independent framework for compressing large genome collections and testing it on real-world datasets.

❖ What are your strongest results so far?

    The most promising result is the successful application of HLL-based binning combined with phylogenetic ordering on the 661k bacterial genome collection. This demonstrates both feasibility and potential for further improvement.

❖ What is the tentative structure of the thesis?

    The thesis will likely be structured in two main chapters:

        Taxonomy-independent ordering of large genome collections — efficient, scalable strategies for computing similarity-preserving orders.

        Batching of ordered genomes under user-defined constraints — practical bin-packing algorithms for use cases like compression, indexing, and distributed storage.

❖ What are the major open questions or uncertainties?

        How scalable is the new framework when pushed to tens of millions of genomes?

        Can species information be fully eliminated, or does it provide significant value for batching?

        What is the best trade-off between ordering quality and computational cost?

❖ What are your next concrete steps (next 6 months)?

        Finalize and document the new reordering + batching framework.

        Run extended experiments on the AllTheBacteria dataset.

        Develop a new tool (possibly a successor to MiniPhy2) to scale to larger collections.

        Prepare a software release, publish recompressed datasets (e.g. via Zenodo), and submit a first paper.

    ⚠️ The riskiest step is scaling up the phylogenetic ordering algorithm to millions of genomes without relying on expensive tree reconstruction.

❖ How will you validate or publish your findings?

    I plan to:

        Release open-source tools (e.g. MiniPhy2, HLL-binning) on GitHub.

        Publish recompressed datasets (e.g. 661k, AllTheBacteria) on Zenodo.

        Submit a first research paper within the first year of the PhD.

❖ What would make this PhD a success in your eyes?

    Beyond achieving good technical results, I would consider the PhD a success if I can provide practical tools that help collaborators and the broader community efficiently compress and structure diverse genome collections—without relying on predefined taxonomies.