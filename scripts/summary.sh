#!/bin/bash
set -Eeuo pipefail
# config variables: PATH_UCC, PATH_UKO, DELIMITER

if [ -s $PATH_UCC ]; then
echo "_UCC_TILTE="Unresolved Conflict Commit"" >> $GITHUB_ENV
declare -a ucc
IFS="$DELIMITER" read -a -r ucc < $PATH_UCC
{
echo "_UCC_BODY<<$DELIMITER"
for i in "${!ucc[@]}"; do
  echo "Confilct $i"
  echo '```diff'
  echo "${ucc[$i]}"
  echo '```'
  echo ''
done
echo $DELIMITER
} >> $GITHUB_ENV
fi

echo "_UKO_TITLE="Unresolved Kernel Option"" >> $GITHUB_ENV
if [ -s $PATH_UKO ]; then
{
echo "_UKO_BODY<<$DELIMITER"
  echo '```diff'
  cat $PATH_UKO
  echo '```'
echo $DELIMITER
} >> $GITHUB_ENV
fi