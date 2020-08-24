#!/bin/bash
set -e

source .env

echo "===================="
echo "03-install-kernel.sh"
echo "===================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

# Notify User
infecho "The env vars that will be used in this script..."
infecho "PP_SD_DEVICE = $PP_IMAGE"
infecho "PP_PARTA = $PP_PARTA"
infecho "PP_PARTB = $PP_PARTB"
echo

# Automatic Preflight Checks
if [[ $EUID -ne 0 ]]; then
    errecho "This script must be run as root!"
    exit 1
fi

# Warning
echo "=== WARNING WARNING WARNING ==="
infecho "This script USES THE DD COMMAND AS ROOT. If the env vars are wrong, this could do something bad."
infecho "Make sure this script is run from the main dir of the repo, since it assumes that's true."
infecho "I'm not responsible for anything that happens, you should read the script first."
echo "=== WARNING WARNING WARNING ==="
echo
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then

    infecho "Writing bootloader..."
    dd if=$KERNEL_RAW_DIR/uboot.bin of=$PP_IMAGE bs=1024 seek=8 && sync

    infecho "Mounting boot partition..."
    mkdir -p bootfs
    mount $PP_PARTA bootfs

    infecho "Compiling kernel..."
    cp files/boot.cmd $KERNEL_RAW_DIR/
    cd $KERNEL_RAW_DIR

    mkimage -A arm64 -T script -C none -d boot.cmd boot.scr
    cd ..

    infecho "Copying kernel..."
    cp $KERNEL_RAW_DIR/boot.scr bootfs/
    cp $KERNEL_RAW_DIR/board.itb bootfs/

    infecho "Unmounting boot partition..."
    umount $PP_PARTA
    rmdir bootfs
fi
