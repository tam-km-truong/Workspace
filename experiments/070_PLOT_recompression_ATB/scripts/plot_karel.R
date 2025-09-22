library(tidyverse)
library(ggsci)
library(tidyr)
library(ggtext)


w <- 16
h <- 13
u <- "cm"

#caption <- "\n\n    PARAMETERS:\n    AGC with -a -b 500 -s 1500; the AGC reference genome is the first genomes in each batch.\n    MBGC with -m 3. All with 25 threads.\n    Batches of Species clusters have 4000 genomes.\n    Batches of dustbin and unknown have 1000 genomes for AGC and MBGC, 4000 genomes for XZ."
caption <- "**Parameters:**    AGC: *-a -b 500 -s 1500*    |    MBGC: *-m 3*    |    XZ: *-9 -T1*"
#caption=""

df_sep_plot <- read_csv('data/seperation_plot_data.csv') %>%
    mutate(compressor = toupper(sub("_.*", "", scheme)))

flatten_df_sep <- df_sep_plot %>%
    pivot_longer(
        cols = c(dustbin, unknown, rest),
        names_to = "group",
        values_to = "size"
    )

flatten_df_sep$scheme <- factor(flatten_df_sep$scheme,
                                levels = c("xz_orig", "xz_mnphy2", "agc", "mbgc"))
flatten_df_sep$compressor <- factor(flatten_df_sep$compressor, levels = c("XZ", "AGC", "MBGC"))
flatten_df_sep$group <- factor(flatten_df_sep$group, levels = c("dustbin", "unknown", "rest"))

flatten_df_sep$value_GB <- flatten_df_sep$size / 1000

ggplot(flatten_df_sep,
       aes(
           x = scheme,
           y = value_GB,
           fill = compressor,
           alpha = group
       )) +
    geom_col(color = "black", linewidth = 0.5) +
    scale_alpha_manual(
        name = "Divisions",
        labels = c(
            "dustbin" = "Dustbin<br/><span style='font-size:9pt'>(n=85k)</span>",
            "unknown" = "Unknown sp.<br/><span style='font-size:9pt'>(n=73k)</span>",
            "rest" = "Regular batches<br/><span style='font-size:9pt'>(n=2,282k)</span>"
        ),
        values = c(0.6, 0.8, 1.0)
    ) +
    scale_fill_npg(name = "Low-level\ncompressor") +
    labs(
        title = "MiniPhy V1 vs. V2",
        subtitle = "(dataset: ATB v0.3, n=2,440,377)",
        x = "",
        y = "Size (GB)" ,
        caption = caption
    ) +
    scale_x_discrete(labels = c("V1+XZ\n(state of the art)", "V2+XZ", "V2+AGC", "V2+MBGC")) +
    theme_classic(base_size = 14) +
    theme(
        plot.subtitle = element_text(color = "gray30"),
        plot.caption = element_markdown(hjust = 0.5),
        legend.text = element_markdown()
    ) +
    geom_text(
        aes(label = paste0(round(value_GB, 1), "GB")),
        position = position_stack(vjust = 0.5),
        size = 3,
        color = "white"
    ) +
    geom_text(
        data = df_plot,
        aes(x = group, y = value_GB, label = label),
        inherit.aes = FALSE,
        vjust = -0.5,
        size = 4,
        fontface = "bold"
    )


fn2 <- "results/compression_results_atb_separated_v2.pdf"
ggsave(fn2,
       width = w,
       height = h,
       units = u)
