process MARK_DUPLICATES {
    tag "$sample_id"
    label 'medium'
    // Contenedor verificado de un solo paquete (Picard), tal como lo usa
    // el módulo oficial de nf-core/modules. El indexado del BAM resultante
    // se hace en un proceso separado (SAMTOOLS_INDEX_DEDUP) con el
    // contenedor de samtools, en vez de depender de un 'mulled' combinado.
    container 'quay.io/biocontainers/picard:3.0.0--hdfd78af_1'
    publishDir { "${params.outdir}/alignment/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    tuple val(sample_id), path("${sample_id}.dedup.bam"), emit: bam
    path "${sample_id}.dedup.metrics.txt", emit: metrics

    script:
    """
    picard MarkDuplicates \\
        INPUT=${bam} \\
        OUTPUT=${sample_id}.dedup.bam \\
        METRICS_FILE=${sample_id}.dedup.metrics.txt \\
        CREATE_INDEX=false
    """
}
