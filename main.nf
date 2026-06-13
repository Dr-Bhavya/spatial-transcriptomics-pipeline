nextflow.enable.dsl=2

process PROCESS_SPATIAL_DATA {
    container 'spatial-seurat-arm64:latest'
    
    publishDir "s3://seurat-spatial-Bhavya/results", mode: 'copy'

    output:
    path "spatial_clusters_overlay.png"
    path "spatial_marker_gene.png"

    script:
    """
    mkdir -p spatial_data
    
    # Download the 10x Genomics Visium Adult Mouse Brain filtered matrix files
    curl -sSL "https://10xgenomics.com" -o matrix.tar.gz
    tar -xzf matrix.tar.gz -C spatial_data --strip-components=1
    
    # Run the production analysis R script 
    Rscript /pipeline/spatial_analysis.R
    """
}

workflow {
    PROCESS_SPATIAL_DATA()
}
