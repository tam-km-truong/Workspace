# Load required libraries

library(tidyverse) 
library(geomtextpath)

compute_equation <- function(df, x, y) {
  
  lm_df <- lm(y ~ x, data = df)
  slope_df <- coef(lm_df)[2]
  intercept_df <- coef(lm_df)[1]
  if (intercept_df<0) {
    equation_df <- paste("y = ", round(slope_df,5), 
                         "x -", round(intercept_df*-1, 5))
  } else {
    equation_df <- paste("y = ", round(slope_df,5), 
                         "x +", round(intercept_df, 5))
  }
  
  return(equation_df)
}

df_cpr <- read_csv("./RESULTS/661k/xz_sizes.csv",col_names = c("size_MB", "name"))
df_cpr <- df_cpr %>% filter(name != "total") 
df_cpr <- df_cpr %>% filter(name != "./_md5.txt") 
df_cpr$name <- sub("\\.tar.xz$", "", df_cpr$name)
df_cpr$name <- gsub("^\\.\\/", "", df_cpr$name)  # Remove leading "./"
df_cpr$species <- gsub("^\\.\\/", "", df_cpr$name)  # Remove leading "./"
df_cpr$species <- gsub("__.*$", "", df_cpr$species)  # Remove everything after "__"
df_cpr$species[df_cpr$species == "s_enterica_0.3_cut_point_placement_order"] <- "Salmonella_enterica"
df_cpr$size_MB <- df_cpr$size_MB/1e+6

# Load distinct k-mer counts
distinct_31mers_batches <- read_csv("./RESULTS/661k/batches_hll_sketches_card.csv", col_names = c("batches", "distinct_31mers"))
distinct_31mers_batches <- distinct_31mers_batches %>% filter(batches != "")
distinct_31mers_batches <- distinct_31mers_batches %>% filter(batches != "filename") 
distinct_31mers_batches$batches <- sub("\\.txt$", "", distinct_31mers_batches$batches)
# Merge datasets based on species names
merged_df <- inner_join(df_cpr, distinct_31mers_batches, by = c("name" = "batches"))
merged_df$distinct_31mers <- as.numeric(merged_df$distinct_31mers)
merged_df$distinct_31mers <- merged_df$distinct_31mers/1e+6
dustbin <- merged_df %>%filter(species == "dustbin")
# popular_species <- c("dustbin", "Escherichia_coli",'Mycobacterium_tuberculosis',
#                     'Salmonella_enterica','Streptococcus_pneumoniae','Staphylococcus_aureus')
popular_species <- c("Escherichia_coli",
                     'Salmonella_enterica','Streptococcus_pneumoniae','Staphylococcus_aureus')

df_popular <- merged_df %>%filter(species %in% popular_species)
# df_dustbin <- merged_df %>%filter(species == "dustbin")
df_escherichia_coli <- merged_df %>%filter(species == "Escherichia_coli")
# df_mycobacterium_tuberculosis <- merged_df %>%filter(species == "Mycobacterium_tuberculosis")
df_salmonella_enterica<- merged_df %>%filter(species == "Salmonella_enterica")
df_staphylococcus_aureus<- merged_df %>%filter(species == "Staphylococcus_aureus")
df_streptococcus_pneumoniae <- merged_df %>%filter(species == "Streptococcus_pneumoniae")

# eq_dustbin<-compute_equation(df_dustbin,df_dustbin$distinct_31mers,df_dustbin$size_MB)
eq_escherichia_coli<-compute_equation(df_escherichia_coli,
                                      df_escherichia_coli$distinct_31mers,df_escherichia_coli$size_MB)
# eq_mycobacterium_tuberculosis<-compute_equation(df_mycobacterium_tuberculosis,
#                                                df_mycobacterium_tuberculosis$distinct_31mers,df_mycobacterium_tuberculosis$size_MB)
eq_salmonella_enterica<-compute_equation(df_salmonella_enterica,
                                         df_salmonella_enterica$distinct_31mers,df_salmonella_enterica$size_MB)
eq_staphylococcus_aureus<-compute_equation(df_staphylococcus_aureus,
                                           df_staphylococcus_aureus$distinct_31mers,df_staphylococcus_aureus$size_MB)
eq_streptococcus_pneumoniae<-compute_equation(df_streptococcus_pneumoniae,
                                              df_streptococcus_pneumoniae$distinct_31mers,df_streptococcus_pneumoniae$size_MB)

# equations<- list(eq_dustbin,eq_escherichia_coli,eq_mycobacterium_tuberculosis,eq_salmonella_enterica,
#                 eq_staphylococcus_aureus,eq_streptococcus_pneumoniae)
equations<- list(eq_escherichia_coli,eq_salmonella_enterica,
                 eq_staphylococcus_aureus,eq_streptococcus_pneumoniae)
# colors<- list("red","gold","green","cyan","blue","pink")
colors<- list("red","green","cyan","pink")

correlations <- df_popular %>%
  group_by(species) %>%
  summarise(cor_value = cor(distinct_31mers, size_MB))

# Generate the plot
plot1<-ggplot(df_popular, aes(x = distinct_31mers, y = size_MB, color = species)) +
  geom_point(shape = 18, size = 4)+
  geom_labelsmooth(aes(label = species), fill = "white",
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) +
  xlim(0, 300) +
  ylim(0, 300) +
  # xlim(0, 2070) +
  # ylim(0, 550) +
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  labs(
    x = "Distinct Kmers (M)",
    y = "Size (MB)",
    title = "Compressed Size vs Distinct Kmers Count - 661k Collection",
    color = "Species"
  )+
  theme(legend.position = c(0.95, 0.05),  # Bottom right
        legend.justification = c(1, 0)) 

# Add correlation and equation text at the top
y_positions <- seq(22 * 1.9, 22 * 0.3, length.out = length(equations))
for (i in seq_along(equations)) {
  plot1 <- plot1 +
    annotate("text", x = 300, y = y_positions[i],
             label = paste0(equations[[i]]),
             color = colors[[i]], size = 5, hjust = 1, fontface = "bold")
}

# y_positions <- seq(50 * 1.9, 50 * 0.3, length.out = length(equations))
# for (i in seq_along(equations)) {
#   plot1 <- plot1 +
#     annotate("text", x = 1000, y = y_positions[i], 
#              label = paste0(equations[[i]]), 
#              color = colors[[i]], size = 5, hjust = 1, fontface = "bold")
# }

plot1

# plot2<-ggplot(merged_df, aes(x = distinct_31mers, y = size_MB)) +
#   geom_point(shape = 20, size = 3) +  # Marker '2' (matches Python's '2' marker)
#   xlim(0, 2070000000) +
#   ylim(0, 550) +
#   theme_minimal(base_size = 14) +
#   theme(
#     panel.border = element_blank(),
#     axis.line = element_line(linewidth = 1.2)
#   ) +
#   labs(
#     x = "Distinct Kmers",
#     y = "Size(MB)",
#     title = "Compressed Size vs Distinct Kmers Count - 661k Collection",
#   )
# plot2

