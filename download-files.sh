#!/bin/bash
set -e

source .env

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

echo "This script will download the Kernel and ca. 900Mb of Fedora raw file into the current directory."
echo
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Download kernel
    infecho "We need to download kernel only for the uboot.bin file"
    infecho "Kernel will be installed from repos"
    wget https://xff.cz/kernels/5.9/pp1.tar.gz -O pp.tar.gz
    tar xf pp.tar.gz
    rm pp.tar.gz

    # Get latest rawhide from repo when not set in .env
    if [ -z "$FEDORA_RAW_FILE" ]
    then
        infecho "Searching for latest Fedora Rawhide..."
        FEDORA_RAW_VER=$(wget -q $FEDORA_RAW_SOURCE -O - | grep -Po '(?<=Fedora-Minimal-Rawhide-).*?(?=.aarch64)' | head -n 1)
        if [ ! -z "$FEDORA_RAW_VER" ]
        then
            infecho "Downloading latest Fedora version: $FEDORA_RAW_VER"
            FEDORA_RAW_FILE=Fedora-Minimal-Rawhide-$FEDORA_RAW_VER.aarch64.raw.xz
        else
            errecho "Could not obtain latest version data"
            errecho "Please visit $FEDORA_RAW_SOURCE uncomment and update the FEDORA_RAW_FILE name in .env with the name on that website."
            exit 1
        fi
    else
        infecho "Downloading Fedora set in .env file: $FEDORA_RAW_FILE"
    fi

    # Download fedora
    wget $FEDORA_RAW_SOURCE/$FEDORA_RAW_FILE -O rawhide.raw.xz
    xz --decompress rawhide.raw.xz
fi
