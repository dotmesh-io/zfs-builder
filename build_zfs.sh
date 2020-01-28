#!/bin/bash
#
# ZFS builder for boot2docker

set -xe

USE_SYSTEM_LINUX=NO

cd /rootfs
rm -rf *

git clone https://github.com/zfsonlinux/zfs.git /zfs/zfs
cd /zfs/zfs
git checkout zfs-0.8.3

# Configure and compile ZFS kernel module
cd /zfs/zfs
./autogen.sh
if [ $USE_SYSTEM_LINUX == "YES" ]
then
	 ./configure \
		  --prefix=/ \
		  --libdir=/lib \
		  --includedir=/usr/include \
		  --datarootdir=/usr/share \
		  --with-config=all
else
	 ./configure \
		  --prefix=/ \
		  --libdir=/lib \
		  --includedir=/usr/include \
		  --datarootdir=/usr/share \
		  --with-linux=/linux-kernel \
		  --with-linux-obj=/linux-kernel \
		  --with-config=all
fi

make -j8
echo "Got after make $?"
make install DESTDIR=/rootfs
echo "Got after make install $?"

cd /rootfs/
tar czfv /rootfs/zfs-${UNAME_R}.tar.gz *
echo "Plopped it into /rootfs/zfs-${UNAME_R}.tar.gz"
