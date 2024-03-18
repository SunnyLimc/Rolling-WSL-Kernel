#!/bin/bash
set -Eeuo pipefail
# config variables: PATH_UCC, PATH_UKO

echo "_UCC_TILTE="Unresolved Conflict Commit"" >> $GITHUB_ENV
delimiter=$'\u00a7'
IFS="$delimiter" read -a -r ucc < ${PATH_UCC//---EOF---/$delimiter}
echo "_UCC_BODY="$(
for i in "${!ucc[@]}"; do
  echo "Confilct $i"
  echo '```diff'
  echo "${ucc[$i]}"
  echo '```'
  echo ''
done)"" >> $GITHUB_ENV

echo "_UKO_TITLE="Unresolved Kernel Option"" >> $GITHUB_ENV
echo "_UKO_BODY=$(cat $PATH_UKO)" >> $GITHUB_ENV