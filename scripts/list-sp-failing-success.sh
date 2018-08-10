#!/bin/bash

root_folder_of_results="/Users/bennibenjamin/Work/xp-jsep-linux/xp-raw-results/out"

echo "commit.hash;semantic.patch;phase1.success;phase2.success\n"
for commitFolder in $root_folder_of_results/*
do
  if [[ ! -d $commitFolder ]]; then
    # echo Skipping $commitFolder
    continue
  fi
  # echo Handling $commitFolder

  filesOld=$(find $commitFolder/outputs/olds/*  -type f -name "*.output")

  for fileOld in $filesOld
  do
    nameOld=$(basename ${fileOld})
    # echo Handling $fileOld $nameOld

    filesNew=$(find $commitFolder/outputs/news/*  -type f -name "*.output")

    for fileNew in $filesNew
    do
      nameNew=$(basename ${fileNew})
      if [[ $nameOld = $nameNew ]]; then

        contentOld=`cat $fileOld`
        contentOldSize=`cat $fileOld | wc -l`

        str="$(basename ${commitFolder})"
        str=${str}";$nameOld"
        if [[ $contentOld = *"coccicheck failed"* ]]; then
          str=${str}";false"
        else
          if [ -z "$(tail -c 2 "$fileOld")" -a $contentOldSize -eq 5 ]; then
            str=${str}";false"
          else
            str=${str}";true"
          fi
        fi


        contentNew=`cat $fileNew`
        contentNewSize=`cat $fileNew | wc -l`
        if [[ $contentNew = *"coccicheck failed"* ]]; then
          str=${str}";false"
        else

          #if contains only 5 lines and the two last one are empty OR contains coccicheck failed => failed
          if [ -z "$(tail -c 2 "$fileNew")" -a $contentNewSize -lt 5 ]; then
            str=${str}";false"
          else
            str=${str}";true"
          fi
        fi

        str=${str}"\n"
        echo -ne $str
      fi

    done
  done
done
