library(tidyverse)
library(RColorBrewer)
df_uncpr <- read_tsv("./jupyter_notebook/data/csv/uncompressed_size_661k.csv",col_names = c("size(MB)", "name"))
df_uncpr <- df_uncpr %>% filter(name != ".") 

df_cpr <- read_tsv("./jupyter_notebook/data/csv/661k_compressed_size.csv",col_names = c("size(MB)", "name"))
df_cpr <- df_cpr %>% filter(name != "total") 
df_cpr <- df_cpr %>% filter(name != "./_md5.txt") 
df_cpr$name <- sub("\\.tar\\.xz$", "", df_cpr$name)
df_cpr$species <- gsub("^\\.\\/", "", df_cpr$name)  # Remove leading "./"
df_cpr$species <- gsub("__.*$", "", df_cpr$species)  # Remove everything after "__"

merged_df <- merge(df_uncpr, df_cpr, by = "name", all = FALSE)
colnames(merged_df) <- c("batch_name", "uncpr_size", "cpr_size", 'species')

# Create the bar plot

ggplot(data = merged_df, aes(x = batch_name, y = uncpr_size, fill = species)) + 
  geom_bar(stat="identity",width = 1)+
  theme_minimal()
  
species_set <- unique(merged_df$species)
colors <- brewer.pal(length(species_set))

# Map species to corresponding colors dynamically
species_color_map <- setNames(colors, species_set)
df$species_color <- species_color_map[df$species]