#!/bin/bash

set -x -e

cd "$(dirname "$0")"

if [[ ! -d "monero_c" ]];
then
    git clone https://github.com/mrcyjanek/monero_c --branch rewrite-wip
    cd monero_c
    git checkout c094ed5da69d2274747bf6edd7ca24124487bd34
    git reset --hard
    git submodule update --init --force --recursive
    ./apply_patches.sh monero
    ./apply_patches.sh wownero
else
    cd monero_c
fi

if [[ ! -f "monero/.patch-applied" ]];
then
    ./apply_patches.sh monero
fi

if [[ ! -f "wownero/.patch-applied" ]];
then
    ./apply_patches.sh wownero
fi
cd ..

echo "monero_c source prepared".
