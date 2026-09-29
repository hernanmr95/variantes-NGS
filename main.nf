#!/usr/bin/env nextflow

/*
 * variant-calling-nf
 * Pipeline reproducible de llamada de variantes germinales (WGS/WES)
 * DSL2 - https://www.nextflow.io/docs/latest/dsl2.html
 */

nextflow.enable.dsl = 2

// ---------------------------------------------------------------------------
// Import de módulos
// ---------------------------------------------------------------------------
include { FASTQC              } from './modules/fastqc.nf'
include { FASTP               } from './modules/fastp.nf'
include { BWA_INDEX           } from './modules/bwa_index.nf'
include { BWA_MEM             } from './modules/bwa_mem.nf'
include { SAMTOOLS_SORT_INDEX } from './modules/samtools_sort_index.nf'
include { MARK_DUPLICATES     } from './modules/mark_duplicates.nf'
include { BCFTOOLS_CALL       } from './modules/bcftools_call.nf'
include { BCFTOOLS_FILTER     } from './modules/bcftools_filter.nf'
include { MULTIQC             } from './modules/multiqc.nf'

// ---------------------------------------------------------------------------
// Workflow principal
// ---------------------------------------------------------------------------
workflow {

    // -- Validación de parámetros (dentro del workflow: las versiones
    //    recientes de Nextflow no permiten sentencias sueltas a nivel de
    //    script mezcladas con declaraciones de proceso/workflow) --------------
    if (!params.input) {
        exit 1, "ERROR: Debes indicar un samplesheet con --input (ver README.md)"
    }
    if (!params.genome) {
        exit 1, "ERROR: Debes indicar una referencia FASTA con --genome"
    }

    Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map { row -> tuple(row.sample, file(row.fastq_1), file(row.fastq_2)) }
        .set { ch_reads }

    ch_genome = Channel.value(file(params.genome))

    // -- Control de calidad crudo -------------------------------------------------
    FASTQC(ch_reads)

    // -- Recorte de adaptadores / filtrado ----------------------------------------
    FASTP(ch_reads)

    // -- Indexado del genoma de referencia (una sola vez) -------------------------
    BWA_INDEX(ch_genome)

    // -- Alineamiento ---------------------------------------------------------------
    BWA_MEM(FASTP.out.reads, BWA_INDEX.out.index, ch_genome)

    // -- Ordenado e indexado del BAM -----------------------------------------------
    SAMTOOLS_SORT_INDEX(BWA_MEM.out.bam)

    // -- Marcado de duplicados ------------------------------------------------------
    MARK_DUPLICATES(SAMTOOLS_SORT_INDEX.out.bam_bai)

    // -- Llamada de variantes ---------------------------------------------------------
    BCFTOOLS_CALL(MARK_DUPLICATES.out.bam_bai, ch_genome)

    // -- Filtrado de variantes --------------------------------------------------------
    BCFTOOLS_FILTER(BCFTOOLS_CALL.out.vcf)

    // -- Informe agregado -------------------------------------------------------------
    if (!params.skip_multiqc) {
        ch_multiqc_files = Channel.empty()
            .mix(FASTQC.out.zip.collect{ it[1] }.ifEmpty([]))
            .mix(FASTP.out.json.collect{ it[1] }.ifEmpty([]))
        MULTIQC(ch_multiqc_files.collect())
    }
}

workflow.onComplete {
    log.info """
    Pipeline completado.
    Éxito     : ${workflow.success}
    Duración  : ${workflow.duration}
    Resultados: ${params.outdir}
    """.stripIndent()
}
