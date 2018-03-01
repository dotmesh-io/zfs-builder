#!/bin/bash
#
# Extract package-installed ZFS modules

set -xe

cd /rootfs
rm -rf *

VERSION=`rpm -ql kmod-zfs | head -1 | sed s_/lib/modules/__ | sed 's_/.*$__'`

tar cf - `rpm -ql kmod-zfs` `rpm -ql kmod-spl` | tar xf -
for VERS in `cd /lib/modules ; ls | grep -v $VERSION`
do
	 ln -s $VERSION lib/modules/$VERS
done

tar czfv /rootfs/zfs-${UNAME_R}.tar.gz lib
echo "Plopped it into /rootfs/zfs-${UNAME_R}.tar.gz"
