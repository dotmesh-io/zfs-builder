#!/bin/bash
#
# ZFS builder for boot2docker

set -xe

USE_SYSTEM_LINUX=NO

cd /rootfs
rm -rf *

git clone https://github.com/zfsonlinux/spl.git /zfs/spl
cd /zfs/spl
git checkout spl-0.6.5.10

git clone https://github.com/zfsonlinux/zfs.git /zfs/zfs
cd /zfs/zfs
git checkout zfs-0.6.5.10

# Configure and compile SPL kernel module
cd /zfs/spl
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
make install DESTDIR=/rootfs

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
		  --with-spl=/zfs/spl \
		  --with-spl-obj=/zfs/spl \
		  --with-config=all
else
	 ./configure \
		  --prefix=/ \
		  --libdir=/lib \
		  --includedir=/usr/include \
		  --datarootdir=/usr/share \
		  --with-spl=/zfs/spl \
		  --with-spl-obj=/zfs/spl \
		  --with-linux=/linux-kernel \
		  --with-linux-obj=/linux-kernel \
		  --with-config=all
fi

make -j8
echo "Got after make $?"
make install DESTDIR=/rootfs
echo "Got after make install $?"

cd /rootfs/
tar cfv /rootfs/zfs-${UNAME_R}.tar.gz *
echo "Plopped it into /rootfs/zfs-${UNAME_R}.tar.gz"
