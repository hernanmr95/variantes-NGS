process SAMTOOLS_INDEX_DEDUP {
    tag "$sample_id"
    label 'low'
    container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_0'
    publishDir { "${params.outdir}/alignment/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path(bam), path("${bam}.bai"), emit: bam_bai

    script:
    """
    samtools index ${bam}
    """
}
