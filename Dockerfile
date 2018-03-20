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
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+TjcqBTJgSyvFdArZpUZLEUgKxO8Wr+wKkKIilCbl7mP3jZnWx8k24x9LZRI4eqSbMFtzlNYOoBCmsPvhtvJFZHGPI8HdOz9cwEC1EZKUi2F/466P1mvo2OPvXVRyCc9JV3Rx3j6yYiIeb00hLfO/Uh60HgF5shl2Ranrw4vKyCVGW5FA9rdVhydrfQirhxHyBTXWmzzVAvCQMFQPa8kYj8mnpIQyYHK7GRbpPvVSksSZ5w7M28mzJ1gtqJGxwOykh0d+O1O7thpWnjwSUC2+xSDzuFTY/YOYVzKT50e0DPUkJQ+jGJbjFAFuFTOfgbgAZTBTZsf97zDO7XV+AZPZ zfs-builder' > /root/.ssh/id_rsa.pub && \
    chmod 0600 /root/.ssh/* && \
    chmod 0700 /root/.ssh
WORKDIR /build
CMD /bin/bash build_kernel_modules.sh