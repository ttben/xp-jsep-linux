#! /bin/bash

function get_info() {
  linux_path=$1
  cd ${linux_path}
echo "hash;commit"
  for commit_hash in "${@:2}"
  do
      # echo handling $commit_hash
       git show  --oneline --pretty='format:%h;%ci' ${commit_hash} | head -n 1
  done
}

get_info ../linux 7007ba630e4a ce8d1015a2b8 847ecd3fa311 15b4dd798149 bce1a65172d1 2551a53053de bfd40eaff5ab 2f53fbd52182 ec663d967b22 827ed2b06b05 e71ff89c712c 5003ae1e735e 96801b35f07e 38651683aa98 4efe37f4c4ef b134bd90286d 25a3ba610609 0d4a6608f68c 78109d230b79
# for commit in `ls ../outputs-result` ; do  git show  --oneline --pretty='format:%h;%cI;%ci' $commit | head -n 1 ; done
