process BCFTOOLS_FILTER {
    tag "$sample_id"
    label 'low'
    container 'quay.io/biocontainers/bcftools:1.19--h8b25389_0'
    publishDir "${params.outdir}/variants/${sample_id}", mode: 'copy'

    input:
    tuple val(sample_id), path(vcf)

    output:
    tuple val(sample_id), path("${sample_id}.filtered.vcf.gz"), emit: vcf

    script:
    """
    bcftools filter \\
        -e 'QUAL<${params.min_qual} || INFO/DP<${params.min_depth}' \\
        -Oz -o ${sample_id}.filtered.vcf.gz \\
        ${vcf}
    bcftools index -t ${sample_id}.filtered.vcf.gz
    """
}
