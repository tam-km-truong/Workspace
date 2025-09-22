#!/usr/bin/env Rscript

#library(tidyverse)

df_mbgc <- read_csv("data/mbgc_compression_sizes.csv",col_names = c("size_MB", "name"))
df_mbgc <- df_mbgc %>%filter(!grepl("^dustbin", name) & !grepl("^unknown", name))
dbin_uknw_mbgc <- read_csv("data/dustbin_unknown_mbgc_1k_batches.csv",col_names = c("size_MB", "name"))
df_mbgc_concat <- bind_rows(df_mbgc,dbin_uknw_mbgc)
df_mbgc_concat <- df_mbgc_concat %>% filter(name != "total")
df_mbgc <- df_mbgc_concat
df_mbgc$size_MB <- df_mbgc$size_MB/1e+6

df_xz_orig <- read_csv("data/xz_orig.csv",col_names = c("size_MB", "name"))
df_xz_orig$size_MB <- df_xz_orig$size_MB/1e+6
df_xz_orig <- df_xz_orig %>% filter(name != "total")

df_agc <- read_csv("data/agc_sizes.csv",col_names = c("size_MB", "name"))
df_agc <- df_agc %>%filter(!grepl("^dustbin", name) & !grepl("^unknown", name))
dbin_uknw_agc <- read_csv("data/dustbin_unknown_agc_1k_batches.csv",col_names = c("size_MB", "name"))
df_agc_concat <- bind_rows(df_agc,dbin_uknw_agc)
df_agc_concat <- df_agc_concat %>% filter(name != "total")
df_agc <- df_agc_concat
df_agc$size_MB <- df_agc$size_MB/1e+6

df_agc <- df_agc %>% filter(name != "total")

df_xz_mnphy2 <- read_csv("data/xz_mnphy2.csv",col_names = c("size_MB", "name"))
df_xz_mnphy2 <- df_xz_mnphy2 %>%filter(!grepl("^dustbin", name) & !grepl("^unknown", name))

dbin_uknw_xz <- read_csv("data/dustbin_unknown_xz_1k_batches.csv",col_names = c("size_MB", "name"))
df_xz_mnphy2_concat <- bind_rows(df_xz_mnphy2,dbin_uknw_xz)
df_xz_mnphy2_concat <- df_xz_mnphy2_concat %>% filter(name != "total")
df_xz_mnphy2 <- df_xz_mnphy2_concat
df_xz_mnphy2$size_MB <- df_xz_mnphy2$size_MB/1e+6
df_xz_mnphy2 <- df_xz_mnphy2 %>% filter(name != "total")


sum_mbgc <- sum(df_mbgc$size_MB)
sum_xz_orig <- sum(df_xz_orig$size_MB)
sum_agc <- sum(df_agc$size_MB)
sum_xz_mnphy2 <- sum(df_xz_mnphy2$size_MB)

df_plot <- data.frame(
  group = c( "xz_orig", "xz_mnphy2", "agc","mbgc"),
  value = c( sum_xz_orig, sum_xz_mnphy2, sum_agc, sum_mbgc)
)

write.csv(df_plot, "data/merged_plot_data.csv", row.names = FALSE)

#Separation of dustbin and unknown batches
sum_dustbin_agc <- sum(df_agc$size_MB[grepl("^dustbin", df_agc$name)])
sum_dustbin_mbgc <- sum(df_mbgc$size_MB[grepl("^dustbin", df_mbgc$name)])
sum_dustbin_xz_orig <- sum(df_xz_orig$size_MB[grepl("^dustbin", df_xz_orig$name)])
sum_dustbin_xz_mnphy2 <- sum(df_xz_mnphy2$size_MB[grepl("^dustbin", df_xz_mnphy2$name)])

sum_unknown_agc <- sum(df_agc$size_MB[grepl("^unknown", df_agc$name)])
sum_unknown_mbgc <- sum(df_mbgc$size_MB[grepl("^unknown", df_mbgc$name)])
sum_unknown_xz_orig <- sum(df_xz_orig$size_MB[grepl("^unknown", df_xz_orig$name)])
sum_unknown_xz_mnphy2 <- sum(df_xz_mnphy2$size_MB[grepl("^unknown", df_xz_mnphy2$name)])

sum_rest_agc <- sum(
  df_agc$size_MB[
    !grepl("^dustbin", df_agc$name) & !grepl("^unknown", df_agc$name)
  ],
  na.rm = TRUE
)
sum_rest_mbgc <- sum(
  df_mbgc$size_MB[
    !grepl("^dustbin", df_mbgc$name) & !grepl("^unknown", df_mbgc$name)
  ],
  na.rm = TRUE
)
sum_rest_xz_orig <- sum(
  df_xz_orig$size_MB[
    !grepl("^dustbin", df_xz_orig$name) & !grepl("^unknown", df_xz_orig$name)
  ],
  na.rm = TRUE
)
sum_rest_xz_mnphy2 <- sum(
  df_xz_mnphy2$size_MB[
    !grepl("^dustbin", df_xz_mnphy2$name) & !grepl("^unknown", df_xz_mnphy2$name)
  ],
  na.rm = TRUE
)

separation_df <- data.frame(
  scheme = c("agc", "mbgc", "xz_orig", "xz_mnphy2"),
  dustbin = c(sum_dustbin_agc, sum_dustbin_mbgc, sum_dustbin_xz_orig, sum_dustbin_xz_mnphy2),
  unknown = c(sum_unknown_agc, sum_unknown_mbgc, sum_unknown_xz_orig, sum_unknown_xz_mnphy2),
  rest    = c(sum_rest_agc, sum_rest_mbgc, sum_rest_xz_orig, sum_rest_xz_mnphy2)
)

write.csv(separation_df, "data/seperation_plot_data.csv", row.names = FALSE)


