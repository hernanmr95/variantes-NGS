process BWA_INDEX {
    tag "$genome.baseName"
    label 'medium'
    container 'quay.io/biocontainers/bwa:0.7.17--hed695b0_7'
    publishDir "${params.outdir}/reference", mode: 'copy'

    input:
    path genome

    output:
    path "${genome}*", emit: index

    script:
    """
    bwa index ${genome}
    """
}
