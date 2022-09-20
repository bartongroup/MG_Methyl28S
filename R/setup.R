okabe_ito_palette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

make_dirs <- function(tb) {
  map(1:nrow(tb), function(i) {
    r <- tb[i, ]
    top_dir <- r$TOP_DIR
    list(
      fscreen = file.path(top_dir, "fscreen"),
      bedgraph = file.path(top_dir, "bedgraph"),
      bedgraph_28S = file.path(top_dir, "bedgraph_28S"),
      bismark = file.path(top_dir, "bismark"),
      bigwig = file.path(top_dir, "bigwig"),
      qc = file.path(top_dir, "qc"),
      bam = file.path(top_dir, "bam"),
      genome = file.path(top_dir, "genome")
    ) 
  }) %>% 
    set_names(tb$NAME)
}

make_metadata <- function(mfile) {
  read_tsv(mfile, show_col_types = FALSE) |> 
    unite(sample, c(group, replicate), remove = FALSE)
}

CHROMOSOMES <- c("2L", "2R", "3L", "3R", "4", "X", "Yq")

EXPERIMENTS <- tibble::tibble(
  NAME = c("pilot"),
  TOP_DIR = c("pilot")
)

