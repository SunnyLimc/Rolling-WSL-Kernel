#!/bin/bash
set -Eeuo pipefail
# config variables: PATH_LINUX_TREE, KCONF_PATH, PATH_UKO

cd "$PATH_LINUX_TREE"
yes | make KCONFIG_CONFIG="../$KCONF_PATH" -j$(nproc)

diff -u "../$KCONFIG_PATH" "../$KCONFIG_PATH.old" >> "../$PATH_UKO"
