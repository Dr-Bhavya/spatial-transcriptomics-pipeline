FROM arm64v8/r-base:4.3.0

ENV DEBIAN_FRONTEND=noninteractive

# Install spatial image compilation requirements and system-level tools
RUN apt-get update && apt-get install -y \
    g++ \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libgfortran5 \
    liblapack-dev \
    libblas-dev \
    libhdf5-dev \
    procps \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/CFLAGS = /CFLAGS = -D_WITHOUT_BASE64_ /g' /usr/lib/R/etc/Makeconf
RUN sed -i 's/CXXFLAGS = /CXXFLAGS = -D_WITHOUT_BASE64_ /g' /usr/lib/R/etc/Makeconf

# Compile structural packages via the primary cloud repository network
RUN R -e "install.packages('matrixStats', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('Seurat', repos='https://cloud.r-project.org')"

# Establish internal execution folders and embed scripts
RUN mkdir /pipeline
COPY spatial_analysis.R /pipeline/spatial_analysis.R
RUN chmod +x /pipeline/spatial_analysis.R
WORKDIR /pipeline
