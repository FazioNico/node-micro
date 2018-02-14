#!/bin/bash

# find packages changed

latestTag=$(git tag | sort -r | head -1)
latestCmt=$(git log -1 --format="%H")

SHA1=fddfbe0 # older
SHA2=8527e51 # newer

packages=$(git diff --name-only ${SHA1} ${SHA2} -- packages  | awk '{ split($0,a,/\//); print a[1]"/"a[2] }' | uniq)

echo $packages
# for dir in $packages; do
#   echo $dir
# done

#
