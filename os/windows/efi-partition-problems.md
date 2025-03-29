# Important:
If multi-booting and you wish to keep old kernels on your system and do system updates on linux using `fwudpmgr` then ensure to allocate more than the default allocation of windows for EFI, the default currently being 100MB, this should be increased to around 300-350MB for a comfortable multi-boot use with minimal problems however 200MB should also be enough altough it might be a little small


## How to allocate EFI before installing windows
Either on any other os partition the drive you are going to use to have an EFI partition using fat32 as its formatting type or as you are about to install windows in the install medium open up CMD and start making a partition for it manually and later choose to install windows in that empty partition.

## I have already installed my system how can i increase it
Unfortuantly theres no way to increase it without the use of third-party tools after the system has been installed so you are just kind of out of luck there, if you do want to use third-party tools search for "Windows how to increase EFI partition" and go to microsoft forums as people have put recommendations on there.

If you happen to have a multi-boot system already setup and dont mind reinstalling windows (and/or grub) you could boot a windows install medium delete the recovery and system partition (and optionally EFI partition) and then increase the size of the EFI partition in CMD still in the boot medium (or create an EFI partition from scratch also note if u did it from scratch you will have to boot a rescue usb for linux and reinstall grub on there as well). NOTE: windows might change boot order or delete grub, if it has changed boot order go into your bios and change it back to what it was (optionally lock it) and if grub was uninstalled boot a rescue live usb for linux and reinstall it.
