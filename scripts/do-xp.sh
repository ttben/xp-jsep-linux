#!/bin/bash

linux_bkp_folder="/home/benni/xps/linux/"
result_folder="/home/benni/xps/result-linux-coccicheck/"
commit_hash=$1
full_path=${result_folder}${commit_hash}

echo "XP started: $date"
echo "Current folder: $PWD"
echo "linux_bkp_folder:$linux_bkp_folder"
echo "result_folder:$result_folder"
echo "commit_hash:$commit_hash"
echo "full_path:$full_path"

echo "Init. context, copying linux files..."
mkdir -p ${full_path}
cp -r $linux_bkp_folder/ ${full_path}
ls -l

cd ${full_path}/linux
git checkout $commit_hash

List all patch
for patch in all patch
  apply it and save the result to "previous_patches_applied-patch.log"
end

make coccicheck >> ./coccicheck.log
