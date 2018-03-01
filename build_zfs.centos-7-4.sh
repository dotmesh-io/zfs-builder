#!/bin/bash
#
# Extract package-installed ZFS modules

set -xe

cd /rootfs/
tar cfv /rootfs/zfs-${UNAME_R}.tar.gz `rpm -ql zfs`
echo "Plopped it into /rootfs/zfs-${UNAME_R}.tar.gz"
