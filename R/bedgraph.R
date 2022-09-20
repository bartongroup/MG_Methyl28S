read_bedgraphs <- function(path, meta, min_level = 0, suffix = "bedgraph", skip = 0) {
  bg <- map2_dfr(meta$raw_sample, meta$sample, function(rsam, sam) {
    bfile <- file.path(path, glue::glue("{rsam}.{suffix}"))
    stopifnot(file.exists(bfile))
    read_tsv(bfile, col_names = c("chr", "start", "end", "score"), col_types = "ciid", skip = skip) |> 
      add_column(sample = sam)
  })
  if(min_level > 0) {
    chrs <- bg |> 
      group_by(sample, chr) |>
      summarise(top = max(score)) |>
      filter(top > min_level) |> 
      pull(chr) |> 
      unique()
    bg <- bg |> 
      filter(chr %in% chrs)
  }
  bg
}

# convert regions to single bases
unpack_bedgraph <- function(bg) {
  bg |> 
    rowwise() |>
    group_split() |> 
    map_dfr(function(r) {
      tibble(
        sample = r$sample,
        chr = r$chr,
        pos = (r$start + 1):r$end,
        score = r$score
      )
    })
}

# take bedgraph (for a given chr and sample) and isolate contiguous
# blocks of counts > min_level, index them as block = 1, 2, 3, ...
isolate_blocks <- function(b, min_level) {
  r <- rle(b$score > min_level)
  tibble(
    length = r$lengths,
    is_peak = r$values
  ) |> 
    mutate(idx = cumsum(is_peak)) |> 
    mutate(idx = if_else(is_peak, idx, 0L)) |> 
    mutate(
      i1 = c(1, cumsum(length[1:(n() - 1)]) + 1),
      i2 = c(cumsum(length))
    ) |> 
    filter(is_peak) |> 
    mutate(
      start = b[i1, ]$start,
      end = b[i2, ]$end
    )
}


extract_peaks <- function(bgs, min_level = 10, margin = 10) {
  bgs |> 
    group_split(sample, chr) |> 
    map_dfr(function(b) {
      blocks <- b |> 
        isolate_blocks(min_level)
      bu <- unpack_bedgraph(b)
      blocks |> 
        rowwise() |> 
        group_split() |> 
        map_dfr(function(r) {
          bu |> 
            filter(pos >= r$start - margin & pos <= r$end + margin) |> 
            add_column(block = r$idx)
        })
    })
}


plot_blocks <- function(bl, smpl, ncol = 5) {
  bl |>
    filter(sample == smpl) |> 
    unite(chrb, c(chr, block), sep = ":", remove = FALSE) |> 
  ggplot() +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
    ) +
    geom_col(aes(x = pos, y = score), width = 1, fill = "grey30", colour = "grey30") +
    facet_wrap(~ chrb, ncol = ncol, scales = "free") +
    scale_x_continuous() +
    scale_y_continuous(expand = expansion(mult = c(0, 0.03))) +
    labs(x = NULL, y = "Count")
}

