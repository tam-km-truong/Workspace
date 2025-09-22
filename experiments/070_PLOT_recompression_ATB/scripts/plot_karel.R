library(tidyverse)
library("ggsci")
library(tidyr)

w <- 16
h <- 13
u <- "cm"

#caption <- "\n\n    PARAMETERS:\n    AGC with -a -b 500 -s 1500; the AGC reference genome is the first genomes in each batch.\n    MBGC with -m 3. All with 25 threads.\n    Batches of Species clusters have 4000 genomes.\n    Batches of dustbin and unknown have 1000 genomes for AGC and MBGC, 4000 genomes for XZ."
caption <- "Parameters:    AGC: -a -b 500 -s 1500    |    MBGC: -m 3    |    XZ: -9 -T1"
#caption=""

df_sep_plot <- read_csv('data/seperation_plot_data.csv')

flatten_df_sep <- df_sep_plot %>%
    pivot_longer(
        cols = c(dustbin, unknown, rest),
        names_to = "group",
        values_to = "size"
    )

flatten_df_sep$scheme <- factor(flatten_df_sep$scheme,
                                levels = c("xz_orig", "xz_mnphy2", "agc", "mbgc"))
flatten_df_sep$group <- factor(flatten_df_sep$group, levels = c("dustbin", "unknown", "rest"))

flatten_df_sep$value_GB <- flatten_df_sep$size / 1000

ggplot(flatten_df_sep,
       aes(
           x = scheme,
           y = value_GB,
           fill = scheme,
           alpha = group
       )) +
    geom_col(color = "black", linewidth = 0.5) +
    scale_alpha_manual(
        labels = c(
            "dustbin" = "dustbin\n(n=85k)\n",
            "unknown" = "unknown\n(n=73k)\n",
            "rest" = "regular batches\n(n=2,282k)\n"
        ),
        values = c(0.6, 0.8, 1.0)
    ) +
    scale_fill_npg(name = "Batch types") +
    labs(
        title = "MiniPhy V1 vs. V2",
        subtitle = "(dataset: ATB v0.3, n=2,440,377)",
        x = "",
        y = "Size (GB)" ,
        caption = caption
    ) +
    scale_x_discrete(
        labels = c(
            "V1+XZ\n(state of the art)",
            "V2+XZ",
            "V2+AGC",
            "V2+MBGC"
        )
    ) +
    theme_classic(base_size = 14) +
    theme(plot.subtitle = element_text(color = "gray30"),
          plot.caption = element_text(hjust = 0.5)) +
    # theme(
    #     plot.caption = element_text(
    #         hjust = 0,
    #         vjust = 0.2,
    #         size = 10
    #     ),
    #     plot.title   = element_text(hjust = 0.5, size = 16),
    #
    # ) +
    #annotation
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
