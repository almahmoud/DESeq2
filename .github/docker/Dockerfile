# syntax=docker/dockerfile:1

ARG BIOCONDUCTOR_TAG=devel
FROM ghcr.io/bioconductor/bioconductor:${BIOCONDUCTOR_TAG}

ARG BIOCONDUCTOR_TAG
LABEL org.opencontainers.image.title="DESeq2" \
      org.opencontainers.image.description="Bioconductor ${BIOCONDUCTOR_TAG} with DESeq2 installed from source, alongside every package listed in its DESCRIPTION, Suggests included." \
      org.opencontainers.image.base.name="ghcr.io/bioconductor/bioconductor:${BIOCONDUCTOR_TAG}" \
      org.opencontainers.image.licenses="LGPL-3.0-or-later"

# The dependency layer is keyed on the DESCRIPTION and the scripts alone, so
# that editing the R sources does not reinstall it.
WORKDIR /tmp/dependencies

COPY DESCRIPTION ./DESCRIPTION
COPY .github/docker/dependencies.R \
     .github/docker/install-dependencies.R \
     .github/docker/verify-installation.R ./

RUN Rscript install-dependencies.R

# DESeq2 itself is built from this checkout rather than pulled from the
# Bioconductor repositories, so the image matches the commit that produced it.
COPY . /tmp/DESeq2

RUN MAKEFLAGS="-j$(nproc)" R CMD INSTALL /tmp/DESeq2

RUN Rscript verify-installation.R

WORKDIR /
RUN rm -rf /tmp/dependencies /tmp/DESeq2 /tmp/Rtmp* /tmp/downloaded_packages
