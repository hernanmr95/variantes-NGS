# Changelog

Todos los cambios relevantes de este proyecto se documentan en este archivo.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).

## [Unreleased]

### Planeado
- Anotación funcional de variantes con VEP o snpEff.
- Detección de variantes estructurales (Manta) y CNVs.
- Llamada conjunta (joint genotyping) para cohortes multi-muestra.
- Soporte para GATK HaplotypeCaller como alternativa a bcftools call.

## [1.0.0] - 2026-09-09

### Añadido
- Workflow principal en Nextflow DSL2: FastQC → fastp → BWA-MEM → samtools →
  MarkDuplicates → bcftools call → bcftools filter → MultiQC.
- Perfiles `docker`, `singularity`, `test` y `cluster`.
- Datos sintéticos de test (`assets/test_data/`) para validación rápida end-to-end.
- Pipeline de CI en GitHub Actions (lint + test automático).
- Documentación de uso y estructura del repositorio.
