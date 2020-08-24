# Sample boot script that is executed by u-boot, set your kernel params here
#
if test ${mmc_bootdev} -eq 0 ; then
	echo "Booting from SD";
	setenv bootdev 0;
else
	echo "Booting from eMMC";
	setenv bootdev 2;
fi;

setenv bootargs console=ttyS0,115200 console=tty1 root=/dev/mmcblk${bootdev}p2 rootfstype=f2fs rw rootwait panic=3 quiet loglevel=0

# Change to board-rd.itb if you use ramdisk
load mmc ${mmc_bootdev}:1 0x44000000 board.itb
bootm 0x44000000
