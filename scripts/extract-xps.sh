#!/bin/bash

home_result="/Users/benjaminbenni/Desktop/_res_"

cd ${home_result}

for entry in "${home_result}"/*
do
  if [ -d "$entry" ] ; then
    echo "$entry"
    cd ${entry}
    commit_hash=`basename $entry`
    unzip output.zip
    mv ./home/benni/xp/src/${commit_hash}/outputs ./
    rm -rf ./home/
    # exit 0
  fi
done
