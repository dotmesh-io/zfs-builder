#!/bin/bash
set -x
for X in stable edge; do
    mkdir -p tmp
    cd tmp
    curl -sSL -o Docker.dmg https://download.docker.com/mac/$X/Docker.dmg
    7z x Docker.dmg >/dev/null
    FILE_WITH_LINUX="`find Docker -type f -exec grep -q '#1 SMP' {} \; -print`"
    strings "$FILE_WITH_LINUX" |grep "#1 SMP" |awk '{print $1}' |awk -F "-" '{print $1}'
    cd ..
    rm -rf tmp
done
