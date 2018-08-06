  #!/bin/bash

# TODO REPLACE WITH $2 AND $1
# path_to_linux_original_src="/Users/benjaminbenni/Desktop/xps/linux"
path_to_xps_result="~/Desktop/_res_/"

echo "Path to xps:${path_to_xps_result}"
#cd ${path_to_xps_result}

for folder_commit in "$path_to_xps_result"/* ; do
  echo "Handling ${folder_commit}"
  if [ -d "${folder_commit}" ] ; then
    cd ${folder_commit}
    commit_hash=`basename $folder_commit`
      echo "Handling commit $commit_hash"
      # cp -r $path_to_linux_original_src .
      # git checkout $filename
      for patch in "$folder_commit"/outputs/* ; do
        echo "Patch $patch"
        patch -p 1 -d ${file}/linux/ < ${patch}
      done
  fi
done
