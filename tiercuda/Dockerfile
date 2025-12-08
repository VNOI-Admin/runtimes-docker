FROM nvidia/cuda:12.8.1-devel-ubuntu24.04 AS base

# Install run-time dependencies in base image
RUN apt-get -y update && apt-get install -y \
    libc6 \
    libstdc++6 \
    libprotobuf32 \
    libnl-route-3-200

FROM base AS build

# Install build dependencies only in builder image
RUN apt-get install -y \
    autoconf \
    bison \
    flex \
    gcc \
    g++ \
    git \
    libprotobuf-dev \
    libnl-route-3-dev \
    libtool \
    make \
    pkg-config \
    protobuf-compiler

RUN git clone https://github.com/google/nsjail.git /nsjail

RUN cd /nsjail && make clean && make

FROM base AS run

# Copy over build result and trim image
RUN rm -rf /var/lib/apt/lists/*
COPY --from=build /nsjail/nsjail /bin

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl file gcc g++ python3-full python3-pip python3-dev python3-setuptools python3-wheel cython3 libseccomp-dev bzip2 gzip \
        fp-compiler libxtst6 tini ca-certificates-java openjdk-8-jdk-headless openjdk-8-jre-headless \
        $([ "$(arch)" = aarch64 ] && echo binutils-arm-linux-gnueabihf) && \
    mkdir -p /etc/perl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -m judge

ENTRYPOINT ["/usr/bin/tini", "/code/run"]
