#/bin/bash
cd linux

git log master \
  --since=2017-01-01 \
  --abbrev-commit \
  --oneline \
  --no-merges \
  --date-order \
  --reverse \
  --date=local \
  --date=short \
  --pretty='format:%h' >../out/gitlog1718.commits

cd ..
