FROM ubuntu:artful

RUN apt-get update && apt-get -y install curl p7zip-full binutils rsync ssh

RUN curl -o /tmp/docker.tgz \
        https://download.docker.com/linux/static/edge/x86_64/docker-17.10.0-ce.tgz && \
    cd /tmp/ && \
    tar zxfv /tmp/docker.tgz && \
    cp /tmp/docker/docker /usr/local/bin && \
    chmod +x /usr/local/bin/docker && \
    rm -rf /tmp/docker

ADD build_kernel_modules.sh build_zfs*.sh Dockerfile.* kernel_config.* src/* /build/
ADD d4m-poller/check.sh /build/d4m-poller/

# id_rsa itself comes in via a k8s secret mount on /ssh-keys

RUN mkdir /root/.ssh && \
    echo 'get.dotmesh.io,145.239.204.38 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKdDVkv5RcBXgzQv3oX4TEGbknjGLLcppBK0df8c5pedr+JAYlf4UIkyKlkxxH0iRuf/B3iuhwaqRzTifdtXLL8=' > /root/.ssh/known_hosts && \
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCkJbO3u22GPET1p1uTHOW3A3orTlHT4k/cJTyuBqvbg5y3NFW7xc0G9mvjDIFY1dSNSer50OpTgwAN7WeyUmQYjOLM0vfhbS4AVTeyrBUeGDN1TH1fgzS6IWc+f8UNyx2qnN1qdAO8eJQM3hOjlf3QHRaUyPrXDE4cMVmIKqqdozMqDnPAQXv/jv/hUbtpX2LilQTVz+gMpkASMuE2bVrRAezM1yCN+fwf1CIVkwGGYum+0HiA/JoPayqOvGOKGkpeIK1UC7f9WjG1irr1fg5wnE9m+xxfh5N60ipUJLUmlahOjTTmfrhGxyyEHGEoEP8m9VCxkaKkOiQpGtofXVD zfs-builder' > /root/.ssh/id_rsa.pub && \
    chmod 0600 /root/.ssh/* && \
    chmod 0700 /root/.ssh
WORKDIR /build
CMD /bin/bash build_kernel_modules.sh
