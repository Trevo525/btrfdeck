#!/bin/bash
cd /home/deck/btrfdeck
cp /usr/lib/hwsupport/sdcard-mount.sh ./backup/sdcard-mount.sh
cp /usr/lib/hwsupport/format-sdcard.sh ./backup/format-sdcard.sh
sudo steamos-readonly disable
sudo rm /usr/lib/hwsupport/sdcard-mount.sh && sudo rm /usr/lib/hwsupport/format-sdcard.sh
sudo cp ./modified/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
sudo cp ./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh
sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh /usr/lib/hwsupport/format-sdcard.sh
sudo steamos-readonly enable
