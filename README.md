I would eventually like to make this into a guide to setup btrfs on your microSD card for the steam deck. For right now, I just have to get it working.. :)

The file in this is from the following file:

`/usr/lib/hwsupport/sdcard-mount.sh`

I haven't edited it yet but I am pretty sure I know what I am going to have to do.

## Guide (**Work in Progress**): 
1. Setup `deck` user with a password so that you can run things that need sudo.
    * `passwd deck`
2. Format the SD card.
    * If it is formatted already:
    * If it is not formatted already:
3. Fix the hot swap file.
    * This file is unwritable. Need to solve for that!
    * This is what I am about to figure out. The file in this directory `sdcard-mount.sh` is located in `/usr/lib/hwsupport/sdcard-mount.sh`. Replace it with the one in here. (not edited yet).
4. Remove the password from the deck user.
    * `sudo passwd -d deck`


Thanks to [u/ClinicallyInPain](https://www.reddit.com/user/ClinicallyInPain/) on reddit for compiling some of the resources and to [u/Hanntac](https://www.reddit.com/user/Hanntac/) and [u/leo_vir](https://www.reddit.com/user/leo_vir/) for their contributions!

Sources:
* https://www.reddit.com/r/SteamDeck/comments/taixhw/new_user_questions_current_user_recommendations/
* https://docs.kde.org/trunk5/en/partitionmanager/partitionmanager/partitionmanager.pdf
* https://linuxhint.com/btrfs-filesystem-mount-options/
* https://www.reddit.com/r/SteamDeck/comments/t76wh6/compressing_storage_with_btrfs/
* https://www.reddit.com/r/SteamDeck/comments/t79fqj/comment/hziqcf5/