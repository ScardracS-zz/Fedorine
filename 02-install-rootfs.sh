#!/bin/bash
set -e

source .env

echo "===================="
echo "02-install-rootfs.sh"
echo "===================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

# Automatic Preflight Checks
if [[ $EUID -ne 0 ]]; then
    errecho "This script must be run as root!"
    exit 1
fi

# Warning
echo "=== WARNING WARNING WARNING ==="
infecho "This script will try to mount to /dev/loop0."
infecho "Make sure nothing else is there with: lsblk"
echo "=== WARNING WARNING WARNING ==="
echo
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    infecho "Making mount directories..."
    mkdir -p imgfs
    mkdir -p rootfs

    infecho "Mounting Fedora image..."
    losetup /dev/loop0 rawhide.raw
    partprobe -s /dev/loop0
    mount /dev/loop0p3 imgfs

    infecho "Mounting rootfs..."
    partprobe -s $PP_IMAGE
    sleep 1 # Sometimes it lags.
    mount $PP_PARTB rootfs

    infecho "Copying files..."
    rsync -a --progress imgfs/* rootfs/

    # cp resolv.conf to make dnf working on phone script
    cp /etc/resolv.conf rootfs/etc/resolv.conf

    # cp kernel modules
    cp -r $KERNEL_RAW_DIR/modules/lib/modules rootfs/lib/

    # Make audio working on boot
    cp files/audio.sh rootfs/etc/init.d/

    #Add option to power modem on boot
    mkdir -p rootfs/sys/devices/platform/modem
    cp files/powered rootfs/sys/devices/platform/modem/

    # Install kernel will take care of boot folder
    infecho "Deleting contents of /boot..."
    rm -rf rootfs/boot/*

    infecho "Unmounting everything..."
    umount /dev/loop0p3
    losetup -d /dev/loop0
    umount $PP_PARTB

    infecho "Deleting temp directories..."
    rmdir imgfs
    rmdir rootfs
fi
