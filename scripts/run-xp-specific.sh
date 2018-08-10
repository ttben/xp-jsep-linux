#!/bin/bash
# WARNING DO NOT PASS A PATH TO LINUX SRC THAT ENDS WITH '/'

function log_time() {
  label=$1
  command_to_exec=$2
#echo $command_to_exec
  printf $1:
  /usr/bin/time -f "%x;%P;%e;%S;%U" sh -c "$command_to_exec"
  # gtime -f "%x;%P;%e;%S;%U" sh -c "$command_to_exec"

  # %P   percent of CPU this job got
  # %e   elapsed real time (wall clock) in seconds
  # %S   system (kernel) time in seconds
  # %U   user time in seconds
  # %x   exit status of command
}

function generate_patch() {
  path_to_current_patches=$1
  patches_list=$2
  phase=$3

  for cocci_script in ${patches_list[@]}; do
    name=$(basename ${cocci_script})
    IFS='.' read -ra SPLIT <<<$name
    folder_name_of_script=${SPLIT[0]}
    log_time "time_generate_patches_phase-${phase}-${folder_name_of_script}" "make coccicheck J=8 COCCI=${cocci_script} MODE=patch > ${path_to_current_patches}${folder_name_of_script}.output 2> ${path_to_current_patches}${folder_name_of_script}.error"
  done
}

function handle_commit() {
  linux_src=$1
  commit_hash=$2
  path_to_current_commit=$3

  echo "start_date:" $(date -R)
  echo "handle_commit:" $commit_hash

  #mkdir $path_to_current_commit/linux

  log_time "copying_kernel" "cp -r ${linux_src}/ $path_to_current_commit/linux"

  cd $path_to_current_commit/linux
  git checkout $commit_hash >/dev/null 2>&1

  patches_list=($(find $path_to_current_commit/linux/scripts/coccinelle/ -name "*.cocci")) # Dynamic listing
  echo nb_cocci_scripts:${#patches_list[@]}

  # --- Generate the patches for all semantic patches of coccicheck ----
  path_to_current_patches=${path_to_current_commit}/outputs/olds/
  mkdir -p ${path_to_current_patches}
  generate_patch $path_to_current_patches $patches_list 1
  #  ------------------------------------------------------------------------

  # --- Blindling apply every patches that was previously generated  ----
  for cocci_script in ${patches_list[@]}; do
    name=$(basename ${cocci_script})
    IFS='.' read -ra SPLIT <<<$name
    folder_name_of_script=${SPLIT[0]}
    # echo "Applying patch of ${cocci_script}..."
    # /usr/bin/time -f "%E" patch -f -p 1 -d ${path_to_current_commit}/linux/ < ${path_to_current_patches}${folder_name_of_script}.output
    # gtime -f "%E" patch -f -p 1 -d ${path_to_current_commit}/linux/ <${path_to_current_patches}${folder_name_of_script}.output
    log_time "${cocci_script}" "patch -f -p 1 -d ${path_to_current_commit}/linux/ < ${path_to_current_patches}${folder_name_of_script}.output > ${path_to_current_patches}${folder_name_of_script}.patch.trace 2> ${path_to_current_patches}${folder_name_of_script}.patch.error"
  done
  #  ------------------------------------------------------------------------

  # --- Generate a new set of patches with coccicheck.
  #  If the new set is either empty or different from the first one, OUPSY  ----
  path_to_current_patches=${path_to_current_commit}/outputs/news/ # <---- "news" !
  mkdir -p ${path_to_current_patches}
  generate_patch $path_to_current_patches $patches_list 2
  #  ------------------------------------------------------------------------

  echo "end_date:" $(date -R)

}

function run_xp() {
  PATH_TO_BASE_LINUX=$1 # EX /Users/user/Desktop/linux/
  PATH_TO_OUTPUT=$2
  commits=(${@:3}) # take from the 3rd argument (dont process the first and second ones)

  echo "====== Start ======"
  echo "+ start_date:" $(date -R)
  echo "+ linux_src_folder:${PATH_TO_BASE_LINUX}"
  echo + output_folder: ${PATH_TO_OUTPUT}
  echo + nb_commits_to_handle:${#commits[@]}
  echo "================"

  cd ${PATH_TO_OUTPUT}

  for commit_hash in ${commits[@]}; do
    if [ -d ${PATH_TO_OUTPUT}/${commit_hash} ]; then
      echo "skipping:$commit_hash"
      continue
    fi
    echo "start_commit:" $commit_hash
    path_to_current_commit=/tmp/${commit_hash}

    mkdir ${path_to_current_commit}
    cd ${path_to_current_commit}

    handle_commit ${PATH_TO_BASE_LINUX} ${commit_hash} ${path_to_current_commit} >${path_to_current_commit}/trace.log 2>&1

    if [ $? -eq 0 ]; then
      rm -rf ${path_to_current_commit}/linux
      mv ${path_to_current_commit} ${PATH_TO_OUTPUT}/${commit_hash}
      rm -rf ${path_to_current_commit}
    fi

  done
  echo "+ end_date:" $(date -R)

}

PATH_TO_OUTPUT=$2
xp_date=$(date +%Y-%m-%d_%H-%M-%S)
echo $PATH_TO_OUTPUT
echo $xp_date
run_xp "$@" >${PATH_TO_OUTPUT}/xp-${xp_date}.out 2>&1

# ./run-xp-specific.sh /home/benni/xp/linux /home/benni/xp/out 7007ba630e4a ce8d1015a2b8 847ecd3fa311 15b4dd798149 bce1a65172d1 2551a53053de bfd40eaff5ab 2f53fbd52182 ec663d967b22 827ed2b06b05 e71ff89c712c 5003ae1e735e 96801b35f07e 38651683aa98 4efe37f4c4ef b134bd90286d 25a3ba610609 0d4a6608f68c 78109d230b79


# echo "#! /bin/bash
# ./run-xp-specific.sh /home/benni/xp/linux /home/benni/xp/out 7007ba630e4a ce8d1015a2b8 847ecd3fa311 15b4dd798149 bce1a65172d1 2551a53053de bfd40eaff5ab 2f53fbd52182 ec663d967b22 827ed2b06b05 e71ff89c712c 5003ae1e735e 96801b35f07e 38651683aa98 4efe37f4c4ef b134bd90286d 25a3ba610609 0d4a6608f68c 78109d230b79" > start-xp-2018-08-03_16-00.sh
