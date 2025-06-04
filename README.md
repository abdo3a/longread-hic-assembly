# longread-hic-assembly

A robust and scalable **Nextflow pipeline** for **genome assembly** and **Hi-C-based chromosome scaffolding** using **long reads (ONT or PacBio)** and **Hi-C data**.

---

## 💡 Overview

This pipeline performs:

1. Long-read quality control  
2. De novo genome assembly  
3. Optional polishing  
4. Hi-C read processing & mapping  
5. Chromosome-scale scaffolding  
6. Assembly quality assessment

---

## 🔧 Usage

```bash
nextflow run nf-core/longread-hic-assembly -profile standard \
  --reads_long "data/longreads/*.fastq.gz" \
  --reads_hic_R1 "data/hic/*_R1.fastq.gz" \
  --reads_hic_R2 "data/hic/*_R2.fastq.gz" \
  --genome_size "3.1g" \
  --platform "ont" \
  --outdir "results"
````

## 📁 Input Parameters

| Parameter         | Description                           | Example                |
|------------------|---------------------------------------|------------------------|
| `--reads_long`   | Long-read FASTQ files (ONT/PacBio)    | `reads/*.fastq.gz`     |
| `--reads_hic_R1` | Hi-C R1 FASTQ files *(optional)*       | `hic/*_R1.fastq.gz`    |
| `--reads_hic_R2` | Hi-C R2 FASTQ files *(optional)*       | `hic/*_R2.fastq.gz`    |
| `--genome_size`  | Estimated genome size                  | `3.1g`                 |
| `--platform`     | Long-read platform: `ont` or `pacbio` | `ont`                  |
| `--outdir`       | Output directory                       | `results`              |


## 🔬 Pipeline Steps

### 1. Quality Control
- **Long Reads**: `NanoPlot` or `pycoQC`
- **Hi-C Reads**: `FastQC` + `MultiQC`

### 2. Genome Assembly
- `Flye` for ONT
- `HiCanu` or `Hifiasm` for PacBio HiFi reads

### 3. Optional Polishing
- `Racon` and `Medaka` for ONT
- `Pilon` for Illumina short reads (optional)

### 4. Hi-C Scaffolding *(Optional)*
- If `--reads_hic_R1` and `--reads_hic_R2` are provided:
  - Trim reads with `fastp`
  - Map using `BWA` or `Juicer`
  - Scaffold with `3D-DNA`, `SALSA`, or `YaHS`

### 5. Assembly Evaluation
- Completeness: `BUSCO`
- Metrics: `QUAST`
- Accuracy: `Merqury`

## 📂 Output Structure

````bash
results/
├── qc/
│ ├── longreads/
│ ├── hic/
│ └── multiqc/
├── assembly/
│ └── contigs.fasta
├── polishing/
│ └── polished.fasta
├── hic_scaffolding/
│ ├── scaffolds.fasta
│ └── hic_maps/
├── qc_assembly/
│ ├── busco/
│ ├── quast/
│ └── merqury/
└── reports/
└── multiqc_report.html
````
## 🧱 Module Structure

````bash
workflow/
├── main.nf
├── nextflow.config
└── modules/
├── qc/
│ ├── nanoplot.nf
│ ├── fastqc.nf
├── assembly/
│ ├── flye.nf
│ ├── hifiasm.nf
├── polishing/
│ ├── racon.nf
│ ├── medaka.nf
├── hic/
│ ├── fastp.nf
│ ├── bwa.nf
│ ├── juicer.nf
├── scaffolding/
│ ├── 3ddna.nf
│ ├── salsa.nf
│ ├── yahs.nf
└── qc_assembly/
├── busco.nf
├── quast.nf
├── merqury.nf
````
