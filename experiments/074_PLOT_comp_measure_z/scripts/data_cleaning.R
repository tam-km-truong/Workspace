#!/usr/bin/env Rscript

library(tidyverse)

agc_sizes <- read_csv("data/agc_sizes.csv",col_names = c("size_agc", "name"))
mbgc_sizes <- read_csv("data/mbgc_sizes.csv",col_names = c("size_mbgc", "name"))
xz_sizes <- read_csv("data/xz_sizes.csv",col_names = c("size_xz", "name"))

lpz_phrase <- read_csv("data/nb_phrases.csv",col_names = c("name", 'nb_phrases'))
dist_kmers <- read_csv("data/unq_kmers.csv",col_names = c("name", 'u_kmers'))
nb_genomes <- read_csv("data/nb_genomes.csv",col_names = c("nb_genomes","name"))

merged_df <- agc_sizes %>%
  inner_join(mbgc_sizes, by = "name") %>%
  inner_join(xz_sizes,   by = "name") %>%
  inner_join(lpz_phrase, by = "name") %>%
  inner_join(dist_kmers, by = "name") %>%
  inner_join(nb_genomes, by = "name")


write.csv(merged_df, "data/merged_df.csv", row.names = FALSE)
