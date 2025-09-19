library(tidyverse)
library("ggsci")
library(tidyr)

df_plot <- read_csv('data/merged_plot_data.csv')

df_plot$group <- factor(df_plot$group, levels = df_plot$group)
df_plot$label <- paste0(round(df_plot$value / 1000, 1), "GB")
df_plot$value_GB <- df_plot$value / 1000

caption <- "\n
    PARAMETERS: AGC with -a -b 500 -s 1500; MBGC with -m 3. All with 25 threads.
    Batches of Species clusters have 4000 genomes, of dustbin and unknown batches have 1000 genomes."

# principal bar plot
p <- ggplot(df_plot, aes(x = group, y = value_GB, fill = group)) +
  geom_col(color = "black", linewidth = 0.5) +
  #scale_fill_manual(values = c("steelblue", "tomato", "darkgreen")) +
  scale_fill_npg() +
  labs(
    title = "Compression results - ATB",                  
    x = "Compression Scheme",                              
    y = "Total Size (GB)" ,
    caption = str_wrap(caption, width = 100)
  ) +
  scale_x_discrete(labels = c("MiniPhy-xz (original)", "MiniPhy2-AGC", "MiniPhy2-MBGC")) +
  theme_minimal(base_size = 14) + 
  theme(
    legend.position = "none",
    plot.caption = element_text(hjust = 0, vjust=0.2, size = 10),
    plot.title   = element_text(hjust = 0.5, size = 16)
  ) +
  #annotation
  geom_text(aes(label = label), vjust = -0.5, size = 4)

p

w <- 20
h <- 20
u <- "cm"

fn <- "results/compression_results_atb.pdf"
ggsave(fn, plot = p, width=w, height=h, units=u)


df_sep_plot <- read_csv('data/seperation_plot_data.csv')

flatten_df_sep <- df_sep_plot %>%
  pivot_longer(
    cols = c(dustbin, unknown, rest),
    names_to = "group",
    values_to = "size"
  )

flatten_df_sep$scheme <- factor(flatten_df_sep$scheme, levels = c("xz_orig", "agc", "mbgc"))
flatten_df_sep$group <- factor(flatten_df_sep$group, levels = c("dustbin", "unknown", "rest"))

flatten_df_sep$value_GB <- flatten_df_sep$size / 1000

p2 <- ggplot(flatten_df_sep, aes(x = scheme, y = value_GB, fill = group)) +
  geom_col(color = "black", linewidth = 0.5) +
  scale_fill_npg(
    labels = c("dustbin" = "Dustbin", 
               "unknown" = "Unknown", 
               "rest" = "Species"),
    name = "Batch types"
  ) +
  labs(
    title = "Compression results - ATB",                  
    x = "Compression Scheme",                              
    y = "Size (GB)" ,
    caption = str_wrap(caption, width = 90)
  ) +
  scale_x_discrete(labels = c("MiniPhy-xz (original)", "MiniPhy2-AGC", "MiniPhy2-MBGC")) +
  theme_minimal(base_size = 14) +
  theme(
    plot.caption = element_text(hjust = 0, vjust=0.2, size = 10),
    plot.title   = element_text(hjust = 0.5, size = 16)
  )+
  #annotation
  geom_text(aes(label = paste0(round(value_GB, 1), "GB")), 
            position = position_stack(vjust = 0.5), 
            size = 3, color = "white") +
  geom_text(data = df_plot, 
            aes(x = group, y = value_GB, label = label), 
            inherit.aes = FALSE, 
            vjust = -0.5, size = 4, fontface = "bold")

p2

fn2 <- "results/compression_results_atb_separated.pdf"
ggsave(fn2, plot = p2, width=w, height=h, units=u)
