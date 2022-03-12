#!/bin/bash

set -e

MOUNT_LOCK="/var/run/sdcard-mount.lock"

if [[ -e /dev/mmcblk0 ]]
then
   systemctl stop sdcard-mount@mmcblk0p1.service
   # lock file prevents the mount service from re-mounting as it gets triggered by udev rules
   echo $$ > $MOUNT_LOCK
   parted --script /dev/mmcblk0 mklabel gpt mkpart primary 0% 100%
   sync
   # mkfs.ext4 -m 0 -O casefold -F /dev/mmcblk0p1
   mkfs.btrfs -F /dev/mmcblk0p1
   sync
   rm $MOUNT_LOCK
   systemctl start sdcard-mount@mmcblk0p1.service
   exit 0
fi

exit 1
