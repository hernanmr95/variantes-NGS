process BCFTOOLS_CALL {
    tag "$sample_id"
    label 'medium'
    container 'quay.io/biocontainers/bcftools:1.19--h8b25389_0'
    publishDir { "${params.outdir}/variants/${sample_id}" }, mode: 'copy'

    input:
    tuple val(sample_id), path(bam), path(bai)
    path genome

    output:
    tuple val(sample_id), path("${sample_id}.raw.vcf.gz"), emit: vcf

    script:
    """
    bcftools mpileup -Ou -f ${genome} ${bam} \\
        | bcftools call -mv -Oz -o ${sample_id}.raw.vcf.gz
    bcftools index -t ${sample_id}.raw.vcf.gz
    """
}
