#!/bin/bash
set -e

# bash cleanup.sh || true
clear

# bash download-files.sh
clear

bash 00-create-empty-image.sh
clear

bash 01-partition-drive.sh
clear

bash 02-install-rootfs.sh
clear

bash 03-install-kernel.sh
clear

bash 04-edit-fstab.sh
clear

bash 05-setup-user.sh
clear

bash xz.sh
clear
