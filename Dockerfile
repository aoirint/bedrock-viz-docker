# syntax=docker/dockerfile:1.5

# Based on https://github.com/bedrock-viz/bedrock-viz/blob/cd51bf9b13691ba609a00b1fe5d7010a8dcc61e8/Dockerfile (GPLv2)

ARG BASE_IMAGE=ubuntu:22.04
FROM "${BASE_IMAGE}" AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
    set -eux

    apt-get update
    apt-get install -y \
        cmake \
        g++ \
        git \
        libboost-program-options-dev \
        libpng++-dev \
        zlib1g-dev \
        gosu

    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
    set -eux

    groupadd -o -g 2000 user
    useradd -o -u 2000 -g user -m user
EOF

ARG BEDROCK_VIZ_URL=https://github.com/bedrock-viz/bedrock-viz
# v0.1.8
ARG BEDROCK_VIZ_VERSION=72a6f9cf90448ada29fc4cb3c228f0f6d16c7dff

RUN <<EOF
    set -eux

    mkdir -p /opt/bedrock-viz-build
    chown -R user:user /opt/bedrock-viz-build

    gosu user git clone "${BEDROCK_VIZ_URL}" /opt/bedrock-viz-build
    cd /opt/bedrock-viz-build
    gosu user git checkout "${BEDROCK_VIZ_VERSION}"
    gosu user git submodule update --init --recursive

    gosu user patch -f -p0 < patches/leveldb-1.22.patch
    gosu user patch -f -p0 < patches/pugixml-disable-install.patch
    
    mkdir -p build
    chown -R user:user build
    cd build

    mkdir -p /opt/bedrock-viz
    chown -R user:user /opt/bedrock-viz

    gosu user cmake .. -DCMAKE_INSTALL_PREFIX=/opt/bedrock-viz

    gosu user make
    gosu user make install

    rm -rf /opt/bedrock-viz-build
EOF

FROM "${BASE_IMAGE}" AS runtime

RUN <<EOF
    set -eux
 
    apt-get update
    apt-get install -y \
        libpng16-16 \
        libboost-program-options-dev \
        gosu

    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
    set -eux

    groupadd -o -g 1000 user
    useradd -o -u 1000 -g user -m user
EOF

COPY --from=builder /opt/bedrock-viz /opt/bedrock-viz
ENV PATH=/opt/bedrock-viz/bin:${PATH}

ENTRYPOINT ["gosu", "user", "bedrock-viz"]
