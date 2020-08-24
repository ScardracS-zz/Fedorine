#!/bin/bash
set -e

echo "======================"
echo "01-create-pine-user.sh"
echo "======================"

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

infecho "Adding user pine..."
adduser pine
passwd pine
usermod -aG wheel pine
