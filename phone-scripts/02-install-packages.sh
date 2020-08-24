#!/bin/bash
set -e

echo "==================="
echo "02-install-packages.sh"
echo "==================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

infecho "This adds COPR repository (njha/mobile) and installs phone related packages."
infecho "Only functional on Fedora Rawhide."
dnf copr enable njha/mobile -y


infecho "Removing old kernel..."
dnf remove kernel -y || rpm -e --noscripts kernel-core

infecho "Removing GRUB2. We use u-boot."
dnf remove grub2 -y
rm -rf rootfs/boot/grub2 || true
rm -rf rootfs/etc/grub.d || true
rm rootfs/etc/grub2-efi.cfg || true

infecho "Installing required packages..."
dnf install feedbackd phoc phosh squeekboard gnome-shell ModemManager kgx \
    f2fs-tools chatty calls carbons purple-mm-sms pinephone-helpers nano wget \
    f32-backgrounds-gnome firefox gnome-contacts evolution NetworkManager-wwan \
    rtl8723cs-firmware -y

infecho "Enabling graphical boot..."
systemctl disable initial-setup.service
systemctl enable phosh.service
systemctl set-default graphical.target

infecho "Making COPR higher priority for kernel updates..."
echo "priority=10" >> /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:njha\:mobile.repo
