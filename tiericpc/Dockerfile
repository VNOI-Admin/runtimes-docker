FROM ubuntu:jammy AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl file gcc g++ python3-full python3-pip python3-dev python3-setuptools python3-wheel cython3 libseccomp-dev bzip2 unzip \
        fp-compiler tini ca-certificates-java \
        $([ "$(arch)" = aarch64 ] && echo binutils-arm-linux-gnueabihf)

RUN if [ "$(arch)" = x86_64 ]; then DEB_ARCH=amd64; else DEB_ARCH=arm64; fi && \
    if [ "$(arch)" = x86_64 ]; then OPENJDK_BUILD=24567508; else OPENJDK_BUILD=24567509; fi && \
    OPENJDK_FILES_URL="https://launchpad.net/~openjdk-security/+archive/ubuntu/ppa/+build/$OPENJDK_BUILD/+files" && \
    curl -L -O $OPENJDK_FILES_URL/openjdk-17-jdk-headless_17.0.5+8-2ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $OPENJDK_FILES_URL/openjdk-17-jre-headless_17.0.5+8-2ubuntu1~22.04_$DEB_ARCH.deb && \
    dpkg -i *.deb && rm *.deb

RUN if [ "$(arch)" = x86_64 ]; then DEB_ARCH=amd64; else DEB_ARCH=arm64; fi && \
    if [ "$(arch)" = x86_64 ]; then GCC_BUILD=23596444; else GCC_BUILD=23596445; fi && \
    GCC_FILES_URL="https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/ppa/+build/$GCC_BUILD/+files" && \
    curl -L -O $GCC_FILES_URL/cpp-11_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/g++-11_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/gcc-11_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/gcc-11-base_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/libasan6_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/libgcc-11-dev_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/libstdc++-11-dev_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    curl -L -O $GCC_FILES_URL/libtsan0_11.3.0-1ubuntu1~22.04_$DEB_ARCH.deb && \
    dpkg -i *.deb && rm *.deb

RUN curl -L -okotlin.zip https://github.com/JetBrains/kotlin/releases/download/v1.7.21/kotlin-compiler-1.7.21.zip && \
    unzip kotlin.zip && mv kotlinc /opt/kotlin && rm kotlin.zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -m judge

FROM base AS build

RUN apt-get update && apt-get install -y dpkg-dev devscripts equivs

RUN mkdir /build-pypy3 && \
    cd /build-pypy3 && \
    curl -L -O https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/pypy3/7.3.10+dfsg-1/pypy3_7.3.10+dfsg-1.dsc && \
    curl -L -O https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/pypy3/7.3.10+dfsg-1/pypy3_7.3.10+dfsg.orig-cpython27.tar.xz && \
    curl -L -O https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/pypy3/7.3.10+dfsg-1/pypy3_7.3.10+dfsg.orig.tar.xz && \
    curl -L -O https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/pypy3/7.3.10+dfsg-1/pypy3_7.3.10+dfsg-1.debian.tar.xz && \
    dpkg-source -x pypy3_7.3.10+dfsg-1.dsc && \
    cd pypy3-7.3.10+dfsg && \
    mk-build-deps && apt-get install -y ./pypy3-build-deps_7.3.10+dfsg-1_all.deb && \
    dpkg-buildpackage -us -uc -b

FROM base AS main

COPY --from=build /build-pypy3/pypy3-lib_7.3.10+dfsg-1_amd64.deb pypy3-lib_7.3.10+dfsg-1_amd64.deb
COPY --from=build /build-pypy3/pypy3_7.3.10+dfsg-1_amd64.deb pypy3_7.3.10+dfsg-1_amd64.deb

RUN dpkg -i pypy3-lib_7.3.10+dfsg-1_amd64.deb && dpkg -i pypy3_7.3.10+dfsg-1_amd64.deb && rm -rf *.deb

ENV PATH="/opt/kotlin/bin:${PATH}"

ENTRYPOINT ["/usr/bin/tini", "/code/run"]
