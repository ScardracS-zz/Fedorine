#!/bin/bash
set -e

bash /root/01-create-pine-user.sh
clear

bash /root/02-install-packages.sh
clear

rm /root/*.sh
