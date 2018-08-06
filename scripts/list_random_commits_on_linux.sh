#!/bin/bash
SAMPLE_EACH_TIME=10

hashes=`( ./git-utils.sh --after 2018-01-01 --before 2018-06-01 -n ${SAMPLE_EACH_TIME} ; ./git-utils.sh --after 2017-06-01 --before 2018-01-01 -n ${SAMPLE_EACH_TIME} ; ./git-utils.sh --after 2017-01-01 --before 2017-06-01 -n ${SAMPLE_EACH_TIME} ; ./git-utils.sh --after 2016-06-01 --before 2017-01-01 -n ${SAMPLE_EACH_TIME} ) | cat`

pattern="commits=`git log --pretty=format:%h -n20`"
cat sample.txt | sed -e "s/$pattern/$hashes/" >> result.txt
