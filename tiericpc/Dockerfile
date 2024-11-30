FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl file gcc g++ python3-full python3-pip python3-dev python3-setuptools python3-wheel cython3 libseccomp-dev bzip2 unzip \
        tini ca-certificates-java openjdk-17-jdk-headless openjdk-17-jre-headless \
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

RUN if [ "$(arch)" = x86_64 ]; then PYPY_ARCH=linux64; else PYPY_ARCH="$(arch)"; fi && \
    mkdir /opt/pypy3 && curl -L "https://downloads.python.org/pypy/pypy3.9-v7.3.10-$PYPY_ARCH.tar.bz2" | \
        tar xj -C /opt/pypy3 --strip-components=1 && /opt/pypy3/bin/pypy -mcompileall && \
    rm -f /opt/pypy3/bin/python*

RUN curl -L -okotlin.zip https://github.com/JetBrains/kotlin/releases/download/v1.7.21/kotlin-compiler-1.7.21.zip && \
    unzip kotlin.zip && mv kotlinc /opt/kotlin && rm kotlin.zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -m judge

ENV PATH="/opt/kotlin/bin:/opt/pypy3/bin:${PATH}"

ENTRYPOINT ["/usr/bin/tini", "/code/run"]
