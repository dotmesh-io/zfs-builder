#!/bin/bash
set -e

CACHEDIR=~/zfs-module-cache
mkdir -p $CACHEDIR
RELEASE=releases@get.dotmesh.io:/pool/releases/zfs/

function build {
    echo Building $1 $2 $3
    KERNEL=$1
    UNAME_R=$2
    DISTRO=$3
    DOCKERFILE=$4

    if [ X$DOCKERFILE == X ]
    then
        DOCKERFILE=$DISTRO
    fi

    UNAME_R=$UNAME_R
    FILE=zfs-${UNAME_R}.tar.gz
    if [ -e $CACHEDIR/$FILE ]; then
        echo "Skipping $FILE, already exists"
    else
        KERN_CONF_SUFFIX=$DISTRO
        # allow specializing kernel configs based on kernel version
        if [ -e kernel_config.$KERN_CONF_SUFFIX-$KERNEL ]; then
            KERN_CONF_SUFFIX=$KERN_CONF_SUFFIX-$KERNEL
        fi
        docker build --build-arg KERN_CONF_SUFFIX=$KERN_CONF_SUFFIX --build-arg KERNEL_VERSION=$KERNEL -t dotmesh-io/build-zfs-$DISTRO:${UNAME_R} -f Dockerfile.$DOCKERFILE .
        echo docker run --rm -e UNAME_R=$UNAME_R -v /tmp/zfs-builder:/rootfs dotmesh-io/build-zfs-$DISTRO:${UNAME_R} /build_zfs.sh
        docker run --rm -e UNAME_R=$UNAME_R -v /tmp/zfs-builder:/rootfs dotmesh-io/build-zfs-$DISTRO:${UNAME_R} /build_zfs.sh
        ls -l /rootfs
        cp /rootfs/$FILE $CACHEDIR/
    fi
}

build $1 $1-linuxkit linuxkit

rsync -rvz $CACHEDIR/ $RELEASE
