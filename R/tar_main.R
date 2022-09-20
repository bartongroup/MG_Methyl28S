targets_main <- function() {
  
  setup <- list(
    tar_target(metadata_file, "info/pilot_design.txt", format="file"),
    tar_target(metadata, make_metadata(metadata_file)),
    tar_target(data_dirs, make_dirs(EXPERIMENTS))
  )
  
  qc_rm <- list(
    tar_target(fscreen, parse_fscreens("pilot/fscreen", metadata)),
    tar_target(qcs, parse_qcs("pilot/qc", metadata, paired = TRUE)),
    tar_target(bamstats, parse_bamstats("pilot/merged/bam", metadata))
  )
  
  sequences <- list(
    tar_target(dna_28S, readDNAStringSet("pilot/genome/28S.fa"))
  )
  
  peaks <- list(
    tar_target(bg, read_bedgraphs("pilot/merged/bedgraph", metadata, min_level = 10)),
    tar_target(bgb, extract_peaks(bg, min_level = 30)),
    tar_target(bg_28S, read_bedgraphs("pilot/28S/bedgraph", metadata, min_level = 10)),
    tar_target(bgb_28S, extract_peaks(bg_28S, min_level = 1))
  )
  
  bismark <- list(
    tar_target(biscov, read_coverage("pilot/28S/bismark", metadata))
  )


  report <- list(
    tar_target(tab_bamstats, tabulate_bamstats(bamstats)),
    tar_target(fig_read_qual, plot_qualities(qcs)),
    tar_target(fig_peaks, plot_blocks(bgb, "CTR_1", ncol = 2)),
    tar_target(fig_cov_28S, plot_coverage(biscov)),
    tar_target(fig_seq_28S, plot_28S(bg_28S, dna_28S, from = 3252, to = 3472, smpl = "CTR_1"))
  )

  c(
    setup,
    qc_rm,
    peaks,
    bismark,
    sequences,
    report
    #gviz,
  )
  
}
