library(tidyverse)

df_plot <- read_csv('data/merged_plot_data.csv')

df_plot$group <- factor(df_plot$group, levels = df_plot$group)
df_plot$label <- paste0(round(df_plot$value / 1000, 1), "GB")
df_plot$value_GB <- df_plot$value / 1000

caption <- "\n
    Parameters: AGC with -a -b 500 -s 1500; MBGC with -m 3. All with 25 threads.
    In this experiment, All batches used in Sketree have 4000 genomes.
    \n
    Compression error on 1 batch (unknown_002).
    With MBGC batch unknown_002 couldn't compress, and with AGC, batch unknown_002 is corrupted
    after compression. Max unknown batch size for MBGC is approx 720MB, AGC unknown_002 is approx 2GB"

# principal bar plot
p <- ggplot(df_plot, aes(x = group, y = value_GB, fill = group)) +
  geom_col(color = "black", linewidth = 0.5) +
  scale_fill_manual(values = c("steelblue", "tomato", "darkgreen")) +
  labs(
    title = "Compression results - ATB",                  
    x = "Compression Scheme",                              
    y = "Total Size (MB)" ,
    caption = str_wrap(caption, width = 75)
  ) +
  scale_x_discrete(labels = c("XZ-Original", "AGC-SkeTree", "MBGC-Sketree")) +
  theme_minimal(base_size = 14) + 
  theme(
    legend.position = "none",
    plot.caption = element_text(hjust = 0.5, size = 12),
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

