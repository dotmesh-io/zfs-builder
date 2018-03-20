#!/bin/bash
#
# Extract package-installed ZFS modules

set -xe

cd /rootfs
rm -rf *

VERSION=`rpm -ql kmod-zfs | head -1 | sed s_/lib/modules/__ | sed 's_/.*$__'`

tar cf - `rpm -ql kmod-zfs` `rpm -ql kmod-spl` | tar xf -

ln -s $VERSION lib/modules/3.10.0-693.11.6.el7.x86_64
ln -s $VERSION lib/modules/3.10.0-693.17.1.el7.x86_64

tar czfv /rootfs/zfs-${UNAME_R}.tar.gz lib
echo "Plopped it into /rootfs/zfs-${UNAME_R}.tar.gz"
