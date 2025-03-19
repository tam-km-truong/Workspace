# Load required libraries

library(tidyverse) 
library(geomtextpath)

df_cpr <- read_tsv("./jupyter_notebook/data/csv/661k_compressed_size.csv",col_names = c("size_MB", "name"))
df_cpr <- df_cpr %>% filter(name != "total") 
df_cpr <- df_cpr %>% filter(name != "./_md5.txt") 
df_cpr$name <- sub("\\.tar\\.xz$", "", df_cpr$name)
df_cpr$name <- gsub("^\\.\\/", "", df_cpr$name)  # Remove leading "./"
df_cpr$species <- gsub("^\\.\\/", "", df_cpr$name)  # Remove leading "./"
df_cpr$species <- gsub("__.*$", "", df_cpr$species)  # Remove everything after "__"

# Load distinct k-mer counts
distinct_31mers_batches <- read_csv("./jupyter_notebook/data/csv/distinct_31mers_661k.csv", col_names = c("batches", "distinct_31mers"))
distinct_31mers_batches <- distinct_31mers_batches %>% filter(batches != "")

# Merge datasets based on species names
merged_df <- inner_join(df_cpr, distinct_31mers_batches, by = c("name" = "batches"))
merged_df$distinct_31mers <- as.numeric(merged_df$distinct_31mers)
ecoli <- merged_df %>%filter(species == "dustbin")
popular_species <- c("dustbin", "escherichia_coli",'mycobacterium_tuberculosis',
                     'salmonella_enterica','streptococcus_pneumoniae','staphylococcus_aureus')

df_popular <- merged_df %>%filter(species %in% popular_species)

correlations <- df_popular %>%
  group_by(species) %>%
  summarise(cor_value = cor(distinct_31mers, size_MB))

# Generate the plot
plot1<-ggplot(df_popular, aes(x = distinct_31mers, y = size_MB, color = species)) +
  geom_point(shape = 18, size = 4)+
  geom_labelsmooth(aes(label = species), fill = "white",
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) +
  xlim(0, 2070000000) +
  ylim(0, 550) +
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  labs(
    x = "Distinct Kmers",
    y = "Size(MB)",
    title = "Compressed Size vs Distinct Kmers Count - 661k Collection",
    color = "Species"
  )+
  theme(legend.position = c(0.95, 0.05),  # Bottom right
        legend.justification = c(1, 0)) 
plot1

plot2<-ggplot(merged_df, aes(x = distinct_31mers, y = size_MB)) +
  geom_point(shape = 20, size = 3) +  # Marker '2' (matches Python's '2' marker)
  xlim(0, 2070000000) +
  ylim(0, 550) +
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  labs(
    x = "Distinct Kmers",
    y = "Size(MB)",
    title = "Compressed Size vs Distinct Kmers Count - 661k Collection",
  )
plot2

