#!/bin/bash
set -Eeuo pipefail
# config variables: PATH_LINUX_TREE, KCONF_PATH, PATH_UKO

cd "$PATH_LINUX_TREE-workdir"

set +e
yes '' | make KCONFIG_CONFIG="../$KCONF_PATH" oldconfig 
diff -u "../$KCONF_PATH.old" "../$KCONF_PATH" | grep '^[+-]' >> "../$PATH_UKO"
set -e

make KCONFIG_CONFIG="../$KCONF_PATH" -j$(nproc)