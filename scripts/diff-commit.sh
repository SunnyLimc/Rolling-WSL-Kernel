#!/bin/bash
set -Eeuo pipefail
# Config variables: PATH_MSFT_TREE, ACCEPT_PATCH_CMSG

IFS=';' read -r -a accept_patch_cmsg <<< "$ACCEPT_PATCH_CMSG"

git -C "$PATH_MSFT_TREE" ls-files >> /dev/null
cd "$PATH_MSFT_TREE"

author=$(git log -1 --pretty=format:'%an')
declare -a selective_commits
commits=$(git log --pretty=format:'%H|%an|%s')
readarray -t commits_array <<< "$commits"

for i in "${!commits_array[@]}"; do
  IFS='|' read -r commit_hash commit_author commit_message <<< "${commits_array[$i]}"

  if [ "$commit_author" == "$author" ]; then
    for rule in "${accept_patch_cmsg[@]}"; do
      if [[ $commit_message =~ $rule ]]; then
        echo "Accept commit '$commit_message' (hash: ${commit_hash:0:10}) matches the rule '$rule'"
        selective_commits+=("$commit_hash")
        break
      fi
    done
  else
    break
  fi
done

IFS=';'; echo "_SELECTIVE_COMMITS=${selective_commits[*]}" >> $GITHUB_ENV
