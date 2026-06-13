#!/usr/bin/env Rscript
library(Seurat)

# 10x Genomics Visium public coordinates matrix directory structure
data_dir <- "./spatial_data"
cat("Initializing Seurat pipeline...\n")

# Reconstruct sample matrices 
counts <- Read10X(data.dir = data_dir)
spatial_obj <- CreateSeuratObject(counts = counts, project = "Visium_Mouse_Brain", assay = "Spatial")

# Execute optimization normalization transformations
spatial_obj <- SCTransform(spatial_obj, assay = "Spatial", verbose = FALSE)
spatial_obj <- RunPCA(spatial_obj, assay = "SCT", verbose = FALSE)
spatial_obj <- FindNeighbors(spatial_obj, dims = 1:20, verbose = FALSE)
spatial_obj <- FindClusters(spatial_obj, verbose = FALSE)

# Generate and store analytical visual output targets
png("spatial_clusters_overlay.png", width = 800, height = 800)
SpatialDimPlot(spatial_obj, label = TRUE, label.size = 3)
dev.off()

png("spatial_marker_gene.png", width = 800, height = 800)
# Track Ttr gene: a highly explicit structural marker of the choroid plexus in mouse brain tissue
SpatialFeaturePlot(spatial_obj, features = "Ttr")
dev.off()

cat("Analysis complete. Visual exports successfully prepared.\n")
