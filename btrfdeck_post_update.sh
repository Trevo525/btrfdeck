#!/bin/bash

# TODO  - compare current files against old backup in case Valve made changes
#       - requires password to be set, perhaps edit readme to include that
#       - better logic

set -e

cd /home/deck/btrfdeck || echo "Could not find btrfdeck repo!"
echo "Backing up current files..."
cp /usr/lib/hwsupport/sdcard-mount.sh ./backup/sdcard-mount.sh
#cp /usr/lib/hwsupport/format-sdcard.sh ./backup/format-sdcard.sh
echo "Temporarily disabling readonly filesystem..."
sudo steamos-readonly disable
echo "Removing current files..."
sudo rm /usr/lib/hwsupport/sdcard-mount.sh
#sudo rm /usr/lib/hwsupport/format-sdcard.sh
echo "Copying modified files..."
sudo cp ./modified/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
#sudo cp ./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh
echo "Editing new file permissions..."
sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh /usr/lib/hwsupport/format-sdcard.sh
echo "Re-enabling readonly filesystem..."
sudo steamos-readonly enable
echo "Done!"
read -n1 -sr -p "Press any key to exit..."
exit
