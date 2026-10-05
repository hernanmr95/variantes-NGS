process BWA_MEM {
    tag "$sample_id"
    label 'high'
    // Contenedor verificado: bwa=0.7.17 + samtools=1.12, tomado del módulo
    // oficial bwa/mem de nf-core/modules (no es un hash inventado).
    container 'quay.io/biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:66ed1b38d280722529bb8a0167b0cf02f8a0b488-0'

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
