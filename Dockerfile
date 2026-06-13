FROM rocker/r-ver:4.3.0

ENV DEBIAN_FRONTEND=noninteractive

# Install only minimal system runtime tools
RUN apt-get update && apt-get install -y procps curl && rm -rf /var/lib/apt/lists/*

# Pull down the pre-compiled Arm64 Seurat binary instantly using Posit PPM
RUN R -e "options(repos = c(CRAN = 'https://posit.co')); install.packages(c('matrixStats', 'Seurat'))"

RUN mkdir /pipeline
COPY spatial_analysis.R /pipeline/spatial_analysis.R
RUN chmod +x /pipeline/spatial_analysis.R
WORKDIR /pipeline

