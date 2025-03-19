library(tidyverse)
df_uncpr <- read_tsv("./jupyter_notebook/data/csv/uncompressed_size_661k.csv",col_names = c("size(MB)", "name"))
df_uncpr <- df_uncpr %>% filter(name != ".") 

df_cpr <- read_tsv("./jupyter_notebook/data/csv/661k_compressed_size.csv",col_names = c("size(MB)", "name"))
df_cpr <- df_cpr %>% filter(name != "total") 
df_cpr <- df_cpr %>% filter(name != "./_md5.txt") 
df_cpr$name <- sub("\\.tar\\.xz$", "", df_cpr$name)
