#!/bin/bash
set -e

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

# Notify User
infecho "These are required programs on Fedora"
infecho "This script has to be run once"

# Automatic Preflight Checks
if [[ $EUID -ne 0 ]]; then
    errecho "This script must be run as root!"
    exit 1
fi

dnf install wget xz f2fs-tools dosfstools rsync uboot-tools qemu-user-static
