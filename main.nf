workflow {
  reads_long_ch = Channel.fromPath(params.reads_long)
  reads_hic_R1_ch = params.reads_hic_R1 ? Channel.fromPath(params.reads_hic_R1) : null
  reads_hic_R2_ch = params.reads_hic_R2 ? Channel.fromPath(params.reads_hic_R2) : null

  nanoplot(reads_long_ch)

  if (reads_hic_R1_ch && reads_hic_R2_ch) {
    fastqc([reads_hic_R1_ch, reads_hic_R2_ch])
  }

  if (params.platform == 'ont') {
    flye(reads_long_ch)
  } else {
    hifiasm(reads_long_ch)
  }

  racon()
  medaka()

  if (reads_hic_R1_ch && reads_hic_R2_ch) {
    fastp([reads_hic_R1_ch, reads_hic_R2_ch])
    bwa()
    juicer()
    yahs()
  }

  busco()
  quast()
  merqury()

  multiqc()
}