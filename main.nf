nextflow.enable.dsl=2

process PROCESS_SPATIAL_DATA {
    publishDir "s3://seurat-spatial-Bhavya/results", mode: 'copy'

    input:
    path create_script
    path analysis_script

    output:
    path "spatial_clusters_overlay.png"
    path "spatial_marker_gene.png"

    script:
    """
    # Inside the bash execution string, hashtags are completely valid
    Rscript ${create_script}
    Rscript ${analysis_script}
    """
}

workflow {
    // Nextflow DSL2 comments require double forward slashes
    create_toy_ch = channel.fromPath('./create_toy_data.R')
    spatial_an_ch = channel.fromPath('./spatial_analysis.R')
    
    PROCESS_SPATIAL_DATA(create_toy_ch, spatial_an_ch)
}
