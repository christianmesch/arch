loadkeys sv-latin1

# Create partitions
# sda1:EFI System:/boot:300M
# sda2:/:80G
# sda3:SWAP:16G
# sda4:extended:/home:rest
cfdisk 

# Create file systems
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4
mkswap /dev/sda3
swapon /dev/sda3

# Mount
mount /dev/sda2 /mnt
mkdir /mnt/home
mount /dev/sda4 /mnt/home
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

wifi-menu

pacstrap /mnt base base-devel linux linux-firmware vim git
genfstab -U /mnt >> /mnt/etc/fstab

# Root
arch-chroot /mnt /bin/bash

# Root password
passwd

