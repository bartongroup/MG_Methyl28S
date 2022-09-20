plot_tracks <- function(ref_fasta, bam_file, chr, from, to, hilit = NULL, genome = "28S") {
  
  fa <- readDNAStringSet(ref_fasta)
  seq_track <- SequenceTrack(fa, chr, genome = genome)
  ali_track <- AlignmentsTrack(bam_file, chromosome = chr, genome = genome)
  if(!is.null(hilit)) {
    hi_track <- HighlightTrack(trackList = list(ali_track, seq_track), start = hilit[1], end = hilit[2], chromosome = chr, genome = genome)
  } else {
    hi_track <- NULL
  }
  
  plotTracks(list(hi_track), from = from, to = to, cex = 0.5)
}