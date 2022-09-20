read_coverage <- function(path, meta) {
  map2_dfr(meta$raw_sample, meta$sample, function(rsam, sam) {
    bfile <- file.path(path, str_glue("{rsam}.bismark.cov.gz"))
    stopifnot(file.exists(bfile))
    
    read_tsv(bfile, show_col_types = FALSE,
             col_names = c("chr", "start", "end", "perc_meth", "n_meth", "n_unmeth")) |> 
      add_column(sample = sam)
  })
}



plot_coverage <- function(bc, min_count = 10, ncol = 2) {
  bc |>
    filter(n_meth > min_count) |>
    rename(methylated = n_meth, unmethylated = n_unmeth) |> 
    pivot_longer(c(methylated, unmethylated), names_to = "methyl", values_to = "count") |> 
  ggplot(aes(x = end, y = count, fill = methyl)) +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    geom_col() +
    facet_wrap(~ sample, ncol = ncol) +
    scale_fill_manual(values = c("darkred", "grey60")) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.03))) +
    labs("Position in 28S sequence", y = "Count", fill = "Methylation")
}