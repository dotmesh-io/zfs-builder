FROM ubuntu:artful

RUN apt-get update && apt-get -y install curl p7zip-full binutils

RUN curl -o /tmp/docker.tgz \
        https://download.docker.com/linux/static/edge/x86_64/docker-17.10.0-ce.tgz && \
    cd /tmp/ && \
    tar zxfv /tmp/docker.tgz && \
    cp /tmp/docker/docker /usr/local/bin && \
    chmod +x /usr/local/bin/docker && \
    rm -rf /tmp/docker

ADD build_kernel_modules.sh build_zfs.sh Dockerfile.* kernel_config.* /build/
ADD d4m-poller/check.sh /build/d4m-poller/
WORKDIR /build
CMD /bin/bash build_kernel_modules.sh