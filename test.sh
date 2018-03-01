#!/bin/sh

docker build -t zfs-builder . && docker run -ti -v /tmp/zfs-builder:/rootfs -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/hello:/pool/releases/zfs zfs-builder
