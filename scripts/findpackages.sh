#!/bin/bash

# find packages changed
function get_last_tag_hash {
  tag=$(git tag | sort -r | head -1)
  if [ -n "$tag" ]; then
    git rev-list $tag -n1
  fi
}

latestTag=$(get_last_tag_hash)
latestCmt=$(git log -1 --format="%H")


packages=$(git diff --name-only ${latestTag} ${latestCmt} -- packages  | awk '{ split($0,a,/\//); print a[1]"/"a[2] }' | uniq )

# # echo $packages
# for dir in $packages; do
#   echo $dir | sed 's#.*/##'
# done

#
