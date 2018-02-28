#!/bin/bash
set -e

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
    RELEASEDIR=/pool/releases/zfs
    if [ -e $RELEASEDIR/$FILE ]; then
        echo "Skipping $FILE, already exists"
    else
        KERN_CONF_SUFFIX=$DISTRO
        # allow specializing kernel configs based on kernel version
        if [ -e kernel_config.$KERN_CONF_SUFFIX-$KERNEL ]; then
            KERN_CONF_SUFFIX=$KERN_CONF_SUFFIX-$KERNEL
        fi
        docker build --build-arg KERN_CONF_SUFFIX=$KERN_CONF_SUFFIX --build-arg KERNEL_VERSION=$KERNEL -t lmarsden/build-zfs-$DISTRO:${UNAME_R} -f Dockerfile.$DOCKERFILE .
        echo docker run --rm -e UNAME_R=$UNAME_R -v /tmp/zfs-builder:/rootfs lmarsden/build-zfs-$DISTRO:${UNAME_R} /build_zfs.sh
		  docker run --rm -e UNAME_R=$UNAME_R -v /tmp/zfs-builder:/rootfs lmarsden/build-zfs-$DISTRO:${UNAME_R} /build_zfs.sh
		  ls -l /rootfs
        cp /rootfs/$FILE $RELEASEDIR/
    fi
}

# docker4mac

versions=$(cd d4m-poller && ./check.sh)
echo Building docker4mac versions:
echo $versions
for version in $versions; do
    build ${version} ${version}-linuxkit-aufs linuxkit
    # try to be forward compatible for when versions without aufs patches
    # become edge/stable
    build ${version} ${version}-linuxkit linuxkit
done

# boot2docker
# look up docker version -> kernel mapping here:
# https://github.com/boot2docker/boot2docker/releases

#versions=$(curl -sSL https://github.com/boot2docker/boot2docker/releases|grep Linux |awk '/pub/ {print $3}' |awk -F 'v' '{print $3}' |awk -F '<' '{print $1}')
#echo Building boot2docker versions:
#echo $versions

#for version in $versions; do
#    build $version $version-boot2docker boot2docker
#done

# travis' trusty variant
build 4.4 4.4.0-101-generic ubuntu-trusty travis

# Centos 7
build 3.10 3.10.0-693.11.6.el7.x86_64 centos-7-4
