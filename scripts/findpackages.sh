#!/bin/bash

# find packages changed

latestTag=$(git tag | sort -r | head -1)
latestCmt=$(git log -1 --format="%H")

SHA1=6be19f4
SHA2=fddfbe0

packages=$(git diff --name-only ${SHA1} ${SHA2} -- packages  | awk '{ split($0,a,/\//); print a[1]"/"a[2] }' | uniq)

for dir in $(ls -d  packages/*); do
  echo $dir
done

#
