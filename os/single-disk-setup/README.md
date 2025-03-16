# Single Disk Setup
This is how i setup my multi-boot env using bitlocker for windows os partition encryption, luks for linux os partition encryption and veracrypt for shared volume partition. The shared volume is ntfs.

## linux/setup-encrypted-device
this [script](./linux/setup-encrypted-device) currently writes decrypting and mounting information to /etc/crypttab and /etc/fstab after backing those two files up.

This script must be ran in root and the following env vars must be set before hand: PARTITION (the partition device i.e. /dev/sda1), KEYFILE (path to keyfile used for decrypting i.e. /etc/sda1-keyfile.bin), DSTDIR (where to mount decrypted partition i.e. /mnt/sda1-mountpoint)

The optional env var MOUNT_OPTS_OVERRIDE can be supplied to override default mounting options

The optional env var MOUNT_OPTS_APPEND can be supplied to add to default mounting options

The optional env var DECRYPT_OPTS_OVERRIDE can be supplied to override default decryption options

The optional env var DECRYPT_OPTS_APPEND can be supplied to add to default decryption options

The optional env var MNT_FS_OVERRIDE can be supplied to change the mounted file system from ntfs to something else

The optional env var DECRYPT_PASSWD can be supplied to use a password instead (DECRYPT_OPTS_OVERRIDE MUST BE SUPPLIED AS WELL the KEYFILE env var must also be supplied but can be set to anything as it wont be used)

The mapper name used it auto-generated from the DSTDIR env var (i.e. sda1-mountpoint) and appends decrypted to its end (i.e. sda1-mountpoint-decrypted) this assume DSTDIR basename is unique under /dev/mapper/

### Running
```bash
# set vars (might be fine to not use export. Not tested)
export PARTITION=/dev/sda1
export KEYFILE=/etc/.cryptkey/sda1Keyfile
export DSTDIR=/mnt/Shared_Volume

sudo -E ./setup-encrypted-device

# unset vars
unset PARTITION
unset KEYFILE
unset DSTDIR
```
