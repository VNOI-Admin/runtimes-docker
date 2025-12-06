FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl file gcc g++ openjdk-21-jdk-headless pypy3 python3-full python3-pip python3-dev python3-setuptools python3-wheel cython3 libseccomp-dev bzip2 unzip \
        fp-compiler tini ca-certificates-java \
        $([ "$(arch)" = aarch64 ] && echo binutils-arm-linux-gnueabihf)

RUN curl -L -okotlin.zip https://github.com/JetBrains/kotlin/releases/download/v1.9.24/kotlin-compiler-1.9.24.zip && \
    unzip kotlin.zip && mv kotlinc /opt/kotlin && rm kotlin.zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -m judge

ENV PATH="/opt/kotlin/bin:${PATH}"

ENTRYPOINT ["/usr/bin/tini", "/code/run"]
