# Methylation in 28S in Drosophila melanogaster

RNA dot blot identified a potential locus of a methylated cytosine in 28S which increases its methylation in disease conditionsa and decreases under disease suppressor. A bisulfite sequencing was carried out to confirm the potential site, 3402 in 28S sequence [pdb|3J3E|5](https://www.ncbi.nlm.nih.gov/nucleotide/3J3E_5). This repository contains the code used to analyse sequencing data.

## Usage

### On a Linux cluster

Create and activate a `conda` environment

```
cd pilot
conda create --name methyl28s
conda activate methyl28s
conda install -c bioconda snakemake fastqc multiqc samtools deeptools bowtie2 trim-galore fastq-screen drmaa bismark
```

Download FASTQ files from the archive.

Run snakemake with the provided script. Please note this script might need to be modified to meet the needs of your computing cluster.

```
./run_snake.sh
```

This will trim adapters, perform quality control, download genome files and map reads with Bowtie2, run Bismark and create bedgraph files.

### In RStudio

Once snakemake is finished, we suggest using RStudio. If this is done on a different machinge (I run RStudio on a laptop), some data need to be copied over (see `./get_data.sh` and `./scripts/rsync_include.txt`). Once in RStudio, start in the top project directory. The first step is to create environment using `renv`:

```
install.packages("renv")
renv::restore()
```

This will install all necessary packages. Run the `targets` pipeline.

```
targets::tar_make()
```

This will carry out all the calculations, create objects for the report. The report (`./doc/pilot_report.qmd`) can be created using 

```
quarto::quarto_render("./doc/pilot_report.qmd", output_format = "html")
```

from the RStudio console.

