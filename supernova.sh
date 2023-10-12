#!/usr/bin/env bash

base=$(dirname "$(readlink -f "$0")")
build_folder=$HOME/build/llvm
install_folder=$base/install
linux_folder=$HOME/projects/linux
llvm_folder=$HOME/projects/llvm-project

export PATH="/home/roapsyme/tools/llvm-17.0.2-x86_64/bin:$PATH"

function check_deps() {
    # We only run this when running on GitHub Actions
    [[ -z ${GITHUB_ACTIONS:-} ]] && return 0

    sudo pacman -S --needed base-devel \
        bc \
        bison \
        ccache \
        clang \
        cpio \
        cmake \
        ed \
        elfutils \
        flex \
        git \
        libelf \
        lld \
        llvm \
        ninja \
        openssl \
        pahole \
        patchelf \
        python3 \
        uboot-tools
}

function build_llvm() {
    "$base"/build-llvm.py \
        --build-folder "$build_folder" \
        --install-folder "$install_folder" \
        --install-targets distribution-stripped compiler-rt-stripped llvm-addr2line-stripped llvm-dwarfdump-stripped llvm-strings-stripped llvm-symbolizer-stripped \
        --linux-folder "$linux_folder" \
        --llvm-folder "$llvm_folder" \
        --lto thin \
        --pgo kernel-defconfig-slim \
        --projects clang compiler-rt lld \
        --show-build-commands \
        --targets AArch64 ARM X86 \
        --vendor-string Supernova
}

function all() {
    check_deps
    build_llvm
}

all
