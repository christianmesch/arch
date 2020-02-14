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

# Time and locale
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

vim /etc/locale.gen # Uncomment en_US.UTF-8 UTF-8
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=sv-latin1" > /etc/vconsole.conf

# Hostname
echo "soundwave" >> /etc/hostname
echo "soundwave" >> /etc/hosts

# Root password
passwd

# Grub
pacman -S grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot

grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
reboot
