#!/bin/sh

docker build -t zfs-builder .

docker tag zfs-builder zfs-builder:dev
docker tag zfs-builder quay.io/dotmesh/zfs-builder:dev
docker push quay.io/dotmesh/zfs-builder:dev
