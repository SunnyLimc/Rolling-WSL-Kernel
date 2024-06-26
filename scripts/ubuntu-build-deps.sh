#!/bin/bash

# https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel
sudo apt-get update
sudo apt-get install -y \
    libncurses-dev \
    gawk \
    flex \
    bison \
    openssl \
    libssl-dev \
    dkms \
    libelf-dev \
    libudev-dev \
    libpci-dev \
    libiberty-dev \
    autoconf \
    llvm

sudo apt-get install -y \
    bc \
    dwarves # pahole, commit #1081f7fefad6999b3fe7506f192774a43fbb5eff