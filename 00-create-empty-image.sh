#!/bin/bash
set -e

source .env

echo "========================"
echo "00-create-empty-image.sh"
echo "========================"

echo "Create image called $OUT_NAME? Make sure this doesn't exist or it will be zeroed out."
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Creating 3.7GB blank file called $OUT_NAME."
    dd if=/dev/zero of=$OUT_NAME iflag=fullblock bs=1M count=3500 && sync
    chown scardracs:scardracs $OUT_NAME
fi
