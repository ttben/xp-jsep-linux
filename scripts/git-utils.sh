#!/bin/bash
# git-utils.sh [--after YYYY-MM-dd] [--before YYYY-MM-dd] [-n N]


function shuffle() {
  # -------------------------------------------
  # Shuffle array
  # Contents of array src are shuffled randomly
  # and result is stored in destination array
  # -------------------------------------------
  IFS=$'\n'
  src=($@)
  dest=()
  # Show original array
  # echo -e "\xe2\x99\xa6Original array\xe2\x99\xa6"
  # echo "${src[@]}"
  # Function to check if item already exists in array
  function checkArray
  {
   for item in ${dest[@]}
   do
   [[ "$item" == "$1" ]] && return 0 # Exists in dest
   done
   return 1 # Not found
  }
  # Main loop
  while [ "${#dest[@]}" -ne "${#src[@]}" ]
  do
   rand=$[ $RANDOM % ${#src[@]} ]
   checkArray "${src[$rand]}" || dest=(${dest[@]} "${src[$rand]}")
  done

  echo "${dest[@]}"
}


cd ~/Desktop/linux\ 2
CMD_LINE="git log --pretty=format:%h"

while test $# -gt 0
do
    case "$1" in
        --after)
          shift
          # echo "after $1"
          AFTER=$1
          CMD_LINE="${CMD_LINE} --after ${AFTER}"
            ;;
        --before)
          shift
          # echo "before $1"
          BEFORE=$1
          CMD_LINE="${CMD_LINE} --before ${BEFORE}"

          ;;
        -n)
          shift
          # echo "only $1"
          N=$1
          # CMD_LINE="${CMD_LINE} -n ${N}"
          ;;
        --*) echo "bad option $1"
            ;;
        *) echo "dafuq argument $1"
            ;;
    esac
    shift
done

# echo "Executing $CMD_LINE"
array=(`$CMD_LINE`)
# echo "${#array[@]} commits found between given dates (after $AFTER, before $BEFORE)"
# echo ""
# echo "Randomly selecting $N commits from those ${#array[@]} ones."
printf "%s\n" ${array[@]} | gshuf | head -$N # !!! GSHUF NEEDS brew install coreutils on macos. U can use `shuf` instead on posix platform

# RANDOM=$$$(date +%s)
# selectedexpression=${array[$RANDOM % ${#array[@]} ]}
# echo $selectedexpression

# echo -e "\nShuffling"
# _array="$(shuffle ${array[@]})"
# echo "${_array[@]:0:$N}"
