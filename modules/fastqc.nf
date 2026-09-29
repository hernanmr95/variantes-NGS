process FASTQC {
    tag "$sample_id"
    label 'low'
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    publishDir { "${params.outdir}/fastqc/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(fastq_1), path(fastq_2)

    output:
    tuple val(sample_id), path("*.zip"), emit: zip
    tuple val(sample_id), path("*.html"), emit: html

    script:
    """
    fastqc --quiet --threads ${task.cpus} ${fastq_1} ${fastq_2}
    """
}
