#! /bin/bash

cd /home/benni/xps/linux/
array=`git log --pretty=format:"%h" -n4`
cd /home/benni/xps
parallel --eta ~/do-xp.sh {} ::: $array
