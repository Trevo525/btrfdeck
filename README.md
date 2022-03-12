# btrfdeck - (butter-f-deck)

I would eventually like to make this into a guide to setup btrfs on your microSD card for the steam deck. For right now, I just have to get it working.. :)

Currently, I have two files from the Steam Deck that potentially could fix the microSD card for btrfs. Both of these files were located in the following directory: `/usr/lib/hwsupport/`. I copied them to `./unmodified` and the `./modified` folder will eventually be what you should replace them with.

# Guide (**Work in Progress**): 
1. Setup `deck` user with a password so that you can run things that need sudo.
    * `passwd deck`
2. Backup the old scripts.
    * `mkdir ./backup/`
    * `cp /usr/lib/hwsupport/format-sdcard.sh ./backup/format-sdcard.sh`
    * `cp /usr/lib/hwsupport/sdcard-mount.sh ./backup/sdcard-mount.sh`
3. Disable readonly so that you can make changes to the protected files. **NOTE: this makes your entire "SteamOS" partition readonly. Basically, removing all barriers keeping you from breaking your system. You've been warned**.
    * `sudo steamos-readonly disable`
4. Replace with modified configs.
    * `cp ./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh`
    * `cp ./modified/format-sdcard.sh /usr/lib/hwsupport/sdcard-mount.sh`
5. Disable readonly so that you can make changes to the protected files.
    * `steamos-readonly enable`
6. Format the SD card.
    * `./modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh`
7. Remove the password from the deck user.
    * `sudo passwd -d deck`

## format-sdcard.sh

I just found another file so I am adding it now. `format-sdcard.sh`. Potentially this could be edited to format to btrfs rather than ext4.

Thanks to [u/ClinicallyInPain](https://www.reddit.com/user/ClinicallyInPain/) on reddit for compiling some of the resources and to [u/Hanntac](https://www.reddit.com/user/Hanntac/) and [u/leo_vir](https://www.reddit.com/user/leo_vir/) for their contributions!

Sources:
* https://www.reddit.com/r/SteamDeck/comments/taixhw/new_user_questions_current_user_recommendations/
* https://docs.kde.org/trunk5/en/partitionmanager/partitionmanager/partitionmanager.pdf
* https://linuxhint.com/btrfs-filesystem-mount-options/
* https://www.reddit.com/r/SteamDeck/comments/t76wh6/compressing_storage_with_btrfs/
* https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hziqcf5/