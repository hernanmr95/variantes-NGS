process FASTP {
    tag "$sample_id"
    label 'medium'
    container 'quay.io/biocontainers/fastp:0.23.4--h5f740d0_0'
    publishDir { "${params.outdir}/fastp/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(fastq_1), path(fastq_2)

    output:
    tuple val(sample_id), path("${sample_id}_R1.trim.fastq.gz"), path("${sample_id}_R2.trim.fastq.gz"), emit: reads
    tuple val(sample_id), path("${sample_id}.fastp.json"), emit: json
    path "${sample_id}.fastp.html"

    script:
    """
    fastp \\
        -i ${fastq_1} -I ${fastq_2} \\
        -o ${sample_id}_R1.trim.fastq.gz -O ${sample_id}_R2.trim.fastq.gz \\
        --json ${sample_id}.fastp.json \\
        --html ${sample_id}.fastp.html \\
        --thread ${task.cpus} \\
        --detect_adapter_for_pe
    """
}
