# Sets up partitions for my usage on a single disk multi-boot system. By default C drive will be partitioned into 3 separate partitions
# With windows and linux getting 128GB allocated each and the rest going to a shared NTFS partition

[CmdletBinding()]
param (
    [Parameter(Mandatory=$False, HelpMessage="What drive to resize (will resize it 3 times one for a windows partition annother for linux and last one for shared) (Default: C)")]
    [char]$driveLetter = 'C',

    [Parameter(Mandatory=$False, HelpMessage="what the windows partition size should be in bytes (Default: 137438953472)")]
    [uint64]$windowsPartSize = 137438953472, # 128GB
    
    [Parameter(Mandatory=$False, HelpMessage="what the linux partition size should be in bytes (Default: 137438953472)")]
    [uint64]$linuxPartSize = 137438953472, # 128GB

    [Parameter(Mandatory=$False, HelpMessage="What to format left over partition into (Default: NTFS)")]
    [ValidatePattern("NTFS|ReFS|exFAT|FAT32|FAT")]
    [string]$formatType="NTFS"
)

$driveInfo = Get-Partition -DriveLetter $driveLetter
$linuxAndWindowsSize = $windowsPartSize + $linuxPartSize
$sizeOfShared = $driveInfo.Size - $linuxAndWindowsSize

# Shrink $driveLetter drive to get linux partition out of $driveLetter
Write-Host -ForegroundColor Green "Will resize drive $driveLetter to $windowsPartSize leaving and leaving $($driveInfo.Size - $windowsPartSize) amount of space unformatted for linux partitioning"
Resize-Partition -Confirm -DiskNumber $driveInfo.DiskNumber -PartitionNumber $driveInfo.PartitionNumber -size $windowsPartSize

# create shared partition
$sharedPartDriveLetter = New-Partition -AssignDriveLetter -DiskNumber $driveInfo.DiskNumber -Size $sizeOfShared | Select-Object -Property DriveLetter

# format partition
Format-Volume -Confirm -FileSystem $formatType -DriveLetter $sharedPartDriveLetter.DriveLetter

# disable bitlocker on shared part (will most likely fail but done just incase)
manage-bde -off "${sharedPartDriveLetter.DriveLetter}:"