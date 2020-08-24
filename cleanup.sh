#!/bin/bash

set -e

source .env

umount /dev/loop0p3 || true
umount $PP_PARTB || true
umount $PP_PARTA  || true
rmdir imgfs  || true
rmdir rootfs  || true
rm -rf $KERNEL_RAW_DIR  || true
losetup -d /dev/loop0  || true
rm $OUT_NAME || true
rm $OUT_NAME.xz || true
rm rawhide.raw || true
