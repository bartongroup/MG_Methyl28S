plot_28S <- function(bg, dna, from, to, smpl) {
  s <- dna |> 
    as.character() |> 
    unname() |> 
    str_split("") |> 
    unlist()
  
  tb <- bg |> 
    filter(sample == smpl) |> 
    unpack_bedgraph() |> 
    mutate(dna = s) |> 
    filter(pos >= from - 10 & pos <= to + 10) |> 
    mutate(dna = if_else(pos < from | pos > to, " ", dna))
 
  ggplot(tb, aes(x = pos, y = score)) +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    ) +
    geom_col(width = 1) +
    scale_x_continuous(expand = c(0, 0)) +
    geom_text(aes(y = 0, label = dna), vjust = 1.1, size = 2.5) +
    labs(x = "Position in 28S", y = NULL)
}