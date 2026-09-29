process SAMTOOLS_SORT_INDEX {
    tag "$sample_id"
    label 'medium'
    container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_0'
    publishDir { "${params.outdir}/alignment/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai"), emit: bam_bai

    script:
    """
    samtools sort -@ ${task.cpus} -o ${sample_id}.sorted.bam ${bam}
    samtools index ${sample_id}.sorted.bam
    """
}
