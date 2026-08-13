# syntax=docker/dockerfile:1

ARG BIOCONDUCTOR_TAG=devel
FROM ghcr.io/bioconductor/bioconductor:${BIOCONDUCTOR_TAG}

ARG BIOCONDUCTOR_TAG
LABEL org.opencontainers.image.title="DESeq2" \
      org.opencontainers.image.description="Bioconductor ${BIOCONDUCTOR_TAG} with every package listed in the DESeq2 DESCRIPTION installed, Suggests included." \
      org.opencontainers.image.base.name="ghcr.io/bioconductor/bioconductor:${BIOCONDUCTOR_TAG}" \
      org.opencontainers.image.licenses="LGPL-3.0-or-later"

WORKDIR /tmp/dependencies

# Only the dependency declaration and the scripts are copied, so that a change
# elsewhere in the package does not invalidate the installation layer.
COPY DESCRIPTION ./DESCRIPTION
COPY .github/docker/dependencies.R \
     .github/docker/install-dependencies.R \
     .github/docker/verify-dependencies.R ./

RUN Rscript install-dependencies.R

RUN Rscript verify-dependencies.R

WORKDIR /
RUN rm -rf /tmp/dependencies /tmp/Rtmp* /tmp/downloaded_packages
