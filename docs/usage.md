# Guía de uso detallada

## 1. Preparar la referencia

El genoma de referencia debe estar en formato FASTA. No es necesario indexarlo
manualmente: el proceso `BWA_INDEX` lo hace como parte del pipeline.

```bash
# Ejemplo: descargar un cromosoma de referencia (GRCh38)
wget https://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.21.fa.gz
gunzip Homo_sapiens.GRCh38.dna.chromosome.21.fa.gz
```

## 2. Preparar el samplesheet

Un CSV con tres columnas: `sample`, `fastq_1`, `fastq_2`. Ver `samplesheet.csv`
en la raíz del repo como plantilla.

## 3. Ejecutar

```bash
nextflow run main.nf \
  -profile docker \
  --input samplesheet.csv \
  --genome referencia.fa \
  --outdir results/ \
  --min_depth 15 \
  --min_qual 30
```

## 4. Reanudar una ejecución interrumpida

Nextflow cachea cada proceso completado. Si la ejecución se corta, se puede
reanudar sin repetir pasos ya realizados:

```bash
nextflow run main.nf -profile docker --input samplesheet.csv --genome referencia.fa -resume
```

## 5. Interpretar las salidas

- `results/variants/<sample>/<sample>.filtered.vcf.gz`: variantes finales,
  filtradas por calidad (`QUAL`) y profundidad (`DP`).
- `results/multiqc/multiqc_report.html`: resumen visual de todas las métricas
  de calidad (FastQC, fastp, alineamiento).
- `results/pipeline_info/`: trazas de ejecución, tiempos y uso de recursos por
  proceso — útil para depurar o justificar el dimensionamiento de un clúster.

## 6. Problemas comunes

| Síntoma                                   | Causa probable                                   |
|--------------------------------------------|---------------------------------------------------|
| `bwa: command not found`                   | No se ejecutó con `-profile docker/singularity`   |
| VCF vacío                                  | Profundidad de cobertura insuficiente en la región |
| El pipeline no reanuda tras un fallo        | Falta `-resume` o se limpió el directorio `work/`  |
