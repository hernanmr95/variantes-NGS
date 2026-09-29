process MARK_DUPLICATES {
    tag "$sample_id"
    label 'medium'
    container 'quay.io/biocontainers/mulled-v2-4ce73d19e0d7dc31305f37edc21ea01c9d99f00d:6dc7cd8331f28ad3b6c5c9b06e3a1e0f6f00e9e2-0' // picard + samtools
    publishDir { "${params.outdir}/alignment/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    tuple val(sample_id), path("${sample_id}.dedup.bam"), path("${sample_id}.dedup.bam.bai"), emit: bam_bai
    path "${sample_id}.dedup.metrics.txt", emit: metrics

    script:
    """
    picard MarkDuplicates \\
        INPUT=${bam} \\
        OUTPUT=${sample_id}.dedup.bam \\
        METRICS_FILE=${sample_id}.dedup.metrics.txt \\
        CREATE_INDEX=false

    samtools index ${sample_id}.dedup.bam
    """
}
