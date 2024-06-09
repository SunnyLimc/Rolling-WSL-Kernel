#!/bin/bash
set -Eeuo pipefail
# Config variables: ZEN_RELEASE_URL, ZEN_PATCH_PATH
# External variables: _GITHUB_TOKEN

found_release=false

for row in $(curl -s -H "Authorization: token ${_GITHUB_TOKEN}" "${ZEN_RELEASE_URL}" | jq -r '.[] | @base64'); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  if [ "$(_jq '.prerelease')" == "false" ]; then
    name=$(_jq '.name')
    if [[ $name == *"ZEN kernel"* ]]; then
      version=$(echo "$name" | grep -oP 'v\K[0-9]+\.[0-9]+(\.[0-9]+)?')
      if [ ! -z "$version" ]; then
        echo "Found valid release: $name with version $version"

        asset_url=$(_jq '.assets[] | select(.name | endswith(".zst")) | .browser_download_url')
        if [ ! -z "$asset_url" ]; then
          curl -L -o "${ZEN_PATCH_PATH}.zst" "$asset_url"
          zstd -d "${ZEN_PATCH_PATH}.zst" -o "$ZEN_PATCH_PATH"
          echo "Downloaded: $ZEN_PATCH_PATH"
          echo "VERSION=$version" >> $GITHUB_ENV
          found_release=true
          break
        else
          echo "No .zst file found for version $version"
        fi
      fi
    fi
  fi
done

if [ "$found_release" = false ]; then
  echo "Error: No valid release of Zen found."
  exit 1
fi
