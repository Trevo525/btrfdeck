# btrfdeck - (butter-f-deck)

**I was only just now able to get this to work on my Deck. Don't do this unless you know what you are doing! I will change the text in this notice when I am confident in the guide for non-techy people :-)**

Currently, I have two files from the Steam Deck that potentially could setup the microSD card for btrfs. Both of these files were located in the following directory: `/usr/lib/hwsupport/`. I copied them to `./unmodified` and the `./modified` folder contains edited versions.

# But why?
Great question. There are two reasons why you would want to do this.

1. Saving storage space:  btrfs allows you to apply compression directly to the file system. This can save as much as 40% of space on games. [But don't take my word for it](https://www.reddit.com/r/SteamDeck/comments/t79fqj/formatted_my_sd_card_to_btrfs_managed_to_squeeze/). Another storage saving thing that btrfs allows is de-duplication. I haven't looked into this much so I haven't implement it yet but [I read](https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hzh7fyh/) that there is a lot of redundant data in Proton prefixes.
2. Faster loading times: In my experience with the deck (limited), loading from the microSD card has not been bad. However, microSD is going to be the bottleneck of loading many bigger games because it has only so much bandwidth. If compression saves you ~40% of storage then that means you have 40% less data to load from the microSD, since it's decompressed AFTER being loaded from the card. There is another [reddit thread with more tests](https://www.reddit.com/r/SteamDeck/comments/t8ztuv/btrfs_vs_ext4_tested/), it has a small sample size (tested on one game) but it still looks positive for using compression at the file system level.

# Why not?
The are two arguments that might suggest that this isn't a good idea.
1. Adding compression/decompression will decrease your battery's runtime since it's more work for your CPU.
    * Though that is definetely true, I would argue that the amount that it might decrease would be so small you that it wouldn't even be noticable. I don't know of any tests that have shown how much it affects the power usage, but will update here when I find one. :-D
2. Changing files in the read-only partition is risky.
    * This is also true. Don't do it if you don't know what you are doing. It can however be done without editing anything in the readonly partition. You just have to go in and mount it via desktop mode at every boot and insertion.

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
## 4. Change the filesystem to read-write so that you can make changes to the protected files. 
#### **NOTE: this makes your entire "SteamOS" partition read-write. Basically, removing all barriers keeping you from breaking your system. You've been warned**.
    sudo steamos-readonly disable
## 5. Replace with modified configs.
    sudo rm /usr/lib/hwsupport/sdcard-mount.sh
    sudo cp ./modified/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
    sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh
## 6. Change the filesystem back to read-only so that you can no longer make changes to the protected files.
    sudo steamos-readonly enable
## 7. Format the SD card.
    sudo parted --script /dev/mmcblk0 mklabel gpt mkpart primary 0% 100%
    sudo mkfs.btrfs -f /dev/mmcblk0p1
## 8. Remove the password from the deck user.
    sudo passwd -d deck

From here, I was able to get it to work. I first tried on a 128 GB microSD card and was thinking that it didn't work but it just took me a little bit of time for it to fully mount I guess. I am going to try to get some feedback from people some other Steam Deck owners before I call this guide "working".

# Undo the changes: 
## 1. Setup `deck` user with a password.
    passwd deck
## 2. Change the filesystem to read-write.  
    sudo steamos-readonly disable
## 3. restore from the backup.
    sudo rm /usr/lib/hwsupport/sdcard-mount.sh
    cp ./backup/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
## 4. Change the filesystem back to read-only.
    sudo steamos-readonly enable
## 5. Remove the password from the deck user.
    sudo passwd -d deck


## format-sdcard.sh

I found another file in the same directory. So I added it here. `format-sdcard.sh`. I believe that this file is what is triggered from the "Format SD" button in the Steam Deck UI. Potentially this could be edited to format to btrfs rather than ext4 through the Steam Deck UI so that you don't have to don't have to go to the desktop to format with btrfs. Once I get some tests on the above, I will try to get this setup as well!

**Saved for if I get this to work**:

`/usr/lib/hwsupport/format-sdcard.sh`

`cp /usr/lib/hwsupport/format-sdcard.sh ./backup/format-sdcard.sh`

`sudo rm /usr/lib/hwsupport/format-sdcard.sh`

`sudo cp ./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh`



Thanks to [u/ClinicallyInPain](https://www.reddit.com/user/ClinicallyInPain/) on reddit for compiling some of the resources and to [u/Hanntac](https://www.reddit.com/user/Hanntac/) and [u/leo_vir](https://www.reddit.com/user/leo_vir/) for their contributions! Both of the last two credits helped me through PM so I am incredibly thankful for the both of them!

Sources:
* https://www.reddit.com/r/SteamDeck/comments/taixhw/new_user_questions_current_user_recommendations/
* https://docs.kde.org/trunk5/en/partitionmanager/partitionmanager/partitionmanager.pdf
* https://linuxhint.com/btrfs-filesystem-mount-options/
* https://www.reddit.com/r/SteamDeck/comments/t76wh6/compressing_storage_with_btrfs/
* https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hziqcf5/
* https://serverfault.com/a/767079