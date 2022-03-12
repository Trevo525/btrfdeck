# btrfdeck - (butter-f-deck)

**This is not in a working state. Do not attempt this on your deck!**

Currently, I have two files from the Steam Deck that potentially could setup the microSD card for btrfs. Both of these files were located in the following directory: `/usr/lib/hwsupport/`. I copied them to `./unmodified` and the `./modified` folder contains edited versions.

# Guide (**Work in Progress**):
## 1. Download this project to your home directory of the deck.
    cd ~
    git clone https://github.com/Trevo525/btrfdeck
    cd btrfdeck
## 2. Setup `deck` user with a password so that you can run things that need sudo.
    passwd deck
## 3. Backup the old script.
    mkdir ./backup/
    cp /usr/lib/hwsupport/sdcard-mount.sh ./backup/sdcard-mount.sh
## 4. Disable readonly so that you can make changes to the protected files. 
#### **NOTE: this makes your entire "SteamOS" partition readonly. Basically, removing all barriers keeping you from breaking your system. You've been warned**.
    sudo steamos-readonly disable
## 5. Replace with modified configs.
    sudo rm /usr/lib/hwsupport/sdcard-mount.sh
    sudo cp ./modified/format-sdcard.sh /usr/lib/hwsupport/sdcard-mount.sh
    sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh
## 6. Re-enable readonly so that you can make changes to the protected files.
    sudo steamos-readonly enable
## 7. Format the SD card.
    sudo parted --script /dev/mmcblk0 mklabel gpt mkpart primary 0% 100%
    sudo mkfs.btrfs -f /dev/mmcblk0p1
## 8. Remove the password from the deck user.
    sudo passwd -d deck

# Undo the changes: 
## 1. Setup `deck` user with a password.
    passwd deck
## 2. Disable readonly. 
    sudo steamos-readonly disable
## 3. restore from the backup.
    sudo rm /usr/lib/hwsupport/sdcard-mount.sh
    cp ./backup/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
## 4. Re-enable readonly.
    sudo steamos-readonly enable
## 5. Remove the password from the deck user.
    sudo passwd -d deck

## format-sdcard.sh

I found another file in the same directory. So I added it here. `format-sdcard.sh`. Potentially this could be edited to format to btrfs rather than ext4 through the Steam Deck UI so that you don't have to don't have to go to the desktop to format with btrfs.

**Saved for if I get this to work**:

`/usr/lib/hwsupport/format-sdcard.sh`

`cp /usr/lib/hwsupport/format-sdcard.sh ./backup/format-sdcard.sh`

`sudo rm /usr/lib/hwsupport/format-sdcard.sh`

`sudo cp ./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh`



Thanks to [u/ClinicallyInPain](https://www.reddit.com/user/ClinicallyInPain/) on reddit for compiling some of the resources and to [u/Hanntac](https://www.reddit.com/user/Hanntac/) and [u/leo_vir](https://www.reddit.com/user/leo_vir/) for their contributions!

Sources:
* https://www.reddit.com/r/SteamDeck/comments/taixhw/new_user_questions_current_user_recommendations/
* https://docs.kde.org/trunk5/en/partitionmanager/partitionmanager/partitionmanager.pdf
* https://linuxhint.com/btrfs-filesystem-mount-options/
* https://www.reddit.com/r/SteamDeck/comments/t76wh6/compressing_storage_with_btrfs/
* https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hziqcf5/
* https://serverfault.com/a/767079