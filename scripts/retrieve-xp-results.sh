#!/bin/bash

home_result="/home/benni/xp/out"
target="/home/benni/outputs-result"

mkdir -p ${target}

cd ${home_result}

for entry in "${home_result}"/*
do
  if [ -d "$entry" ] ; then
    echo "$entry"
    commit_hash=`basename $entry`
    mkdir ${target}/${commit_hash}
    cd ${entry}
    echo "wanna zip -r ${entry}/output.zip ${entry}/*"
    zip -r ${entry}/output.zip ${entry}/*
    mv ${entry}/output.zip ${target}/${commit_hash}/
  fi
done
