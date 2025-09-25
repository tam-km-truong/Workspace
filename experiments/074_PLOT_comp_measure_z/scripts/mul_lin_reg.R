library(tidyverse)

df <- read_csv("data/merged_df.csv")

model_xz <- lm(size_xz ~ nb_phrases + u_kmers + nb_genomes, data = df)
summary(model_xz)

model_agc <- lm(size_agc ~ nb_phrases + u_kmers + nb_genomes, data = df)
summary(model_agc)

model_mbgc <- lm(size_mbgc ~ nb_phrases + u_kmers + nb_genomes, data = df)
summary(model_mbgc)
