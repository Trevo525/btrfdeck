# btrfdeck - (butter-f-deck)

**This is potentially unsafe and a little buggy. Don't do this unless you know what you are doing! I will change the text in this notice when I am confident in the guide for non-techy people :-)**

Currently, I have two files from the Steam Deck that potentially could setup the microSD card for btrfs. Both of these files were located in the following directory: `/usr/lib/hwsupport/`. I copied them to `./unmodified` and the `./modified` folder contains the custom edited versions.

## sdcard-mount.sh
This script is what is called when a microSD card is inserted in the slot on the Deck. You can compare the version in `/modified` to `/unmodified` to see exact what I changed but I will summarize them below.

```
if [[ ${ID_FS_TYPE} != "ext4" && ${ID_FS_TYPE} != "btrfs" ]]; then
    exit 1
fi
```
This was already on the file but I added `&& ${ID_FS_TYPE} != "btrfs"`. The if statement without this addition says to not mount anything that is not the filesystem type `ext4`. The addition adds btrfs to the list, simply allowing it mount btrfs formatted drives.

```
if [[ ${ID_FS_TYPE} == "btrfs" ]]; then
    OPTS+=",compress=zstd:15"
fi
```
The block above was added and was not just changed like the previous one. This section means that if filesystem is btrfs add the zstd compression with a level of 15 to the mounting options. I selected 15 as the compression level but I am open to change that if someone provides a good reason to. :-)


## format-sdcard.sh
When you press the "Format SD Card" button in the Steam Deck UI it calls this script. Below is the changes I made.

```
# mkfs.ext4 -m 0 -O casefold -F /dev/mmcblk0p1
mkfs.btrfs -f /dev/mmcblk0p1
```
The top line is commented out, that's what the '#' symbol means. The second line is my replacement that formats with btrfs.

# But why?
Great question. There are three reasons why you would want to do this.

1. Saving storage space:  btrfs allows you to apply compression directly to the file system. This can save as much as 40% of space on games. [But don't take my word for it](https://www.reddit.com/r/SteamDeck/comments/t79fqj/formatted_my_sd_card_to_btrfs_managed_to_squeeze/). Another storage saving thing that btrfs allows is de-duplication. I haven't looked into this much so I haven't implement it yet but [I read](https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hzh7fyh/) that there is a lot of redundant data in Proton prefixes.
2. Faster loading times: In my experience with the deck (limited), loading from the microSD card has not been bad. However, microSD is going to be the bottleneck of loading many bigger games because it has only so much bandwidth. If compression saves you ~40% of storage then that means you have 40% less data to load from the microSD, since it's decompressed AFTER being loaded from the card. There is another [reddit thread with more tests](https://www.reddit.com/r/SteamDeck/comments/t8ztuv/btrfs_vs_ext4_tested/), it has a small sample size (tested on one game) but it still looks positive for using compression at the file system level.
3. Cross-OS compatibility: This is something I never considered when making this but thanks to [The Phawx's Video](https://youtu.be/Pt-Y5DYy9mU) you can see that with the [Open-Source BTRFS Windows Driver](https://github.com/maharmstone/btrfs) you can use the same microSD Steam Library accross SteamOS and Windows.
    * **Warning!** The video only shows one game. I saw in the comments from people experienced with this exact thing on other Linux distros, that many games have different versions on Windows vs Linux (Think Linux Native vs Proton ports). What this might result in is every time you change form one OS to another, it might redownload one or many of your games to match the OS you are currently running. If you intend to try this, I would be aware of this and if a game does this, be sure to remove those games from the shared library.

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
    cp /usr/lib/hwsupport/format-sdcard.sh ./backup/format-sdcard.sh
## 4. Change the filesystem to read-write so that you can make changes to the protected files. 
#### **NOTE: this makes your entire "SteamOS" partition read-write. Basically, removing all barriers keeping you from breaking your system. You've been warned**.
    sudo steamos-readonly disable
## 5. Replace with modified configs.
    sudo rm /usr/lib/hwsupport/sdcard-mount.sh && sudo rm /usr/lib/hwsupport/format-sdcard.sh
    sudo cp ./modified/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
    sudo cp ./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh
    sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh /usr/lib/hwsupport/format-sdcard.sh
## 6. Change the filesystem back to read-only so that you can no longer make changes to the protected files.
    sudo steamos-readonly enable
## 7. Remove the password from the deck user.
    sudo passwd -d deck
## 8. Format the SD card.
    Press the "Format SD Card" button in the Steam Deck UI.

From here, I was able to get it to work. I first tried on a 128 GB microSD card and was thinking that it didn't work but it just took me a little bit of time for it to fully mount I guess. I am going to try to get some feedback from people some other Steam Deck owners before I call this guide "working".

# Undo the changes: 
## 1. Setup `deck` user with a password.
    passwd deck
## 2. Change the filesystem to read-write.  
    sudo steamos-readonly disable
## 3. restore from the backup.
    sudo rm /usr/lib/hwsupport/sdcard-mount.sh && sudo rm /usr/lib/hwsupport/format-sdcard.sh
    cp ./backup/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
    cp ./backup/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh
## 4. Change the filesystem back to read-only.
    sudo steamos-readonly enable
## 5. Remove the password from the deck user.
    sudo passwd -d deck

# Issues
I don't know how to quantify some of the weird issues I am having so just know this isn't perfect but after I've tested it for a little while longer I'll leave some more notes here. If you try this and you have any issues feel free to leave an [issue here](https://github.com/Trevo525/btrfdeck/issues).

# Credits

Thanks to [u/ClinicallyInPain](https://www.reddit.com/user/ClinicallyInPain/) on reddit for compiling some of the resources and to [u/Hanntac](https://www.reddit.com/user/Hanntac/) and [u/leo_vir](https://www.reddit.com/user/leo_vir/) for their contributions! Both of the last two credits helped me through PM so I am incredibly thankful for the both of them!

Sources:
* https://www.reddit.com/r/SteamDeck/comments/taixhw/new_user_questions_current_user_recommendations/
* https://docs.kde.org/trunk5/en/partitionmanager/partitionmanager/partitionmanager.pdf
* https://linuxhint.com/btrfs-filesystem-mount-options/
* https://www.reddit.com/r/SteamDeck/comments/t76wh6/compressing_storage_with_btrfs/
* https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hziqcf5/
* https://serverfault.com/a/767079