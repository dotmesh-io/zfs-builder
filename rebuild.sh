#!/bin/sh

VERSION="`git rev-parse HEAD`"
REMOTE_IMAGE="quay.io/dotmesh/zfs-builder:release-$VERSION"

echo "Building $REMOTE_IMAGE"
docker build -t "$REMOTE_IMAGE" .

echo "Deploying to $REMOTE_IMAGE"
docker push "$REMOTE_IMAGE"
