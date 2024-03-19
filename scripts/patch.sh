#!/bin/bash
set -Eeuo pipefail
# Config variables: PATH_MSFT_TREE, PATH_LINUX_TREE, PRE_PATCH, POST_PATCH, PATH_UCC, MSFT_TREE_DEPTH
# External variables: _SELECTIVE_COMMITS
IFS=';' read -r -a pre_patch <<< "$PRE_PATCH"
IFS=';' read -r -a post_patch <<< "$POST_PATCH"
IFS=';' read -r -a selective_commits <<< "$_SELECTIVE_COMMITS"

git -C "$PATH_MSFT_TREE" ls-files >> /dev/null
git -C "$PATH_LINUX_TREE" ls-files >> /dev/null

for patch in "${PRE_PATCH[@]}"; do
  echo "Applying pre-patch $patch"
  patch -p1 -d "$PATH_LINUX_TREE" < "$patch"
done

cd "$PATH_LINUX_TREE"
git remote add msft "../$PATH_MSFT_TREE"
git fetch --depth=$MSFT_TREE_DEPTH msft

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

for commit_hash in "${selective_commits[@]}"; do
  git cherry-pick -m 1 --allow-empty "$commit_hash"
  if [ $? -ne 0 ]; then
    echo "Conflict detected on commit '${commit_hash:0:10}'. Try resolving using 'ours' (content from HEAD) strategy for all files."
    conflicted_files=$(git diff --name-only --diff-filter=U)
    for file in $conflicted_files; do
      git checkout --ours "$file"
      git add "$file"
    done
    echo "$(git show -s --oneline $commit_hash)" >> "$PATH_UCC"
    echo "$(git diff)" >> "$PATH_UCC"
    echo "---EOF---" >> "$PATH_UCC"
    git -c core.editor=true cherry-pick --continue
  fi
done
cd ".."

for patch in "${POST_PATCH[@]}"; do
  echo "Applying post-patch $patch"
  patch -p1 -d "$PATH_LINUX_TREE" < "$patch"
done
