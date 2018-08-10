#/bin/bash
cd linux

# GET COMMITS INFORMATIONS FROM A FOLDER THAT CONTAINS FOLDER THAT HAVE COMMIT HASHES FOR NAMES
# ----> git log --pretty='format:%cd;%h' --oneline --abbrev-commit $(find ../outputs-result/ -mindepth 1 -maxdepth 1 -type d | cut -d "/" -f 3)

# for commit in `ls ../outputs-result` ; do  git show  --oneline --pretty='format:%h;%cI;%ci' $commit | head -n 1 ; done
# git show  --oneline --pretty='format:%h;%cd' $( git rev-list --no-walk $(find ../outputs-result/ -mindepth 1 -maxdepth 1 -type d | cut -d "/" -f 3))
# for year in {2017..2018}
# do
#   for month in {01..12}
#   do
#
#     git log master \
#       --since=$year-$month-01 \
#       --until=$year-$month-31 \
#       --abbrev-commit \
#       --oneline \
#       --no-merges \
#       --date-order  \
#       --reverse \
#       --date=local \
#       --date=short \
#        --pretty='format:%cd;%h' > ../out/gitlog-$year-$month.commits
#
#   done
# done
# gtime -a -o times.log -f "%x;%P;%e;%S;%U" sh -c '(echo lol && sleep 2) > cmd.log 2>&1'
# %P   percent of CPU this job got
# %e   elapsed real time (wall clock) in seconds
# %S   system (kernel) time in seconds
# %U   user time in seconds
# %x   exit status of command


    git log master \
      --since=2017-01-01 \
      --abbrev-commit \
      --oneline \
      --no-merges \
      --date-order  \
      --reverse \
      --date=local \
      --date=short \
       --pretty='format:%h' > ../out/gitlog1718.commits



cd ..
