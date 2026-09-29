process BWA_MEM {
    tag "$sample_id"
    label 'high'
    container 'quay.io/biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3c34e91d692e50b98ca7-0' // bwa + samtools

    input:
    tuple val(sample_id), path(fastq_1), path(fastq_2)
    path index
    path genome

    output:
    tuple val(sample_id), path("${sample_id}.bam"), emit: bam

    script:
    def read_group = "@RG\\tID:${sample_id}\\tSM:${sample_id}\\tPL:ILLUMINA"
    """
    bwa mem -t ${task.cpus} -R "${read_group}" ${genome} ${fastq_1} ${fastq_2} \\
        | samtools view -bS - > ${sample_id}.bam
    """
}
