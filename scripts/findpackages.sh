#!/bin/bash

# find packages changed
latestRef=$(git log origin/master -1 --format="%H")
latestCmt=$(git log -1 --format="%H")
echo $latestRef
echo $latestCmt
packages=$(git diff --name-only ${latestRef} ${latestCmt} -- packages  | awk '{ split($0,a,/\//); print a[1]"/"a[2] }' | uniq )

# # echo $packages
# for dir in $packages; do
#   echo $dir | sed 's#.*/##'
# done

#
