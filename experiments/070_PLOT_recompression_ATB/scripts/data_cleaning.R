#library(tidyverse)

df_mbgc <- read_csv("data/mbgc_compression_sizes.csv",col_names = c("size_MB", "name"))
df_mbgc$size_MB <- df_mbgc$size_MB/1e+6
df_mbgc <- df_mbgc %>% filter(name != "total")

df_xz_orig <- read_csv("data/xz_orig.csv",col_names = c("size_MB", "name"))
df_xz_orig$size_MB <- df_xz_orig$size_MB/1e+6
df_xz_orig <- df_xz_orig %>% filter(name != "total")

df_agc <- read_csv("data/agc_sizes.csv",col_names = c("size_MB", "name"))
df_agc$size_MB <- df_agc$size_MB/1e+6
df_agc <- df_agc %>% filter(name != "total")

sum_mbgc <- sum(df_mbgc$size_MB)
sum_xz <- sum(df_xz_orig$size_MB)
sum_agc <- sum(df_agc$size_MB)

df_plot <- data.frame(
  group = c( "xz", "agc","mbgc"),
  value = c( sum_xz, sum_agc, sum_mbgc)
)

write.csv(df_plot, "data/merged_plot_data.csv", row.names = FALSE)
