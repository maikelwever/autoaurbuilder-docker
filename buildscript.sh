#!/usr/bin/env bash

echo "Starting build of package "


echo "Initializing gpg"
export HOME=/tmp
dirmngr < /dev/null

for i in $GPG_KEY_FINGERPRINTS
do
    echo "Importing key $i"
    gpg --keyserver keys.gnupg.net --recv $i
done

echo "Enabling builder repository $REPOSITORY_NAME"

echo "" | sudo tee --append /etc/pacman.conf
echo "[$REPOSITORY_NAME]" | sudo tee --append /etc/pacman.conf
echo "SigLevel = Optional TrustAll" | sudo tee --append /etc/pacman.conf
echo "Server = $REPOSITORY_URL/$REPOSITORY_NAME" | sudo tee --append /etc/pacman.conf

echo "Setting 'packager' in /etc/makepkg.conf"
echo "" | sudo tee --append /etc/makepkg.conf
echo "PACKAGER=\"$PACKAGER\"" | sudo tee --append /etc/makepkg.conf

sudo pacman -Syyu --noconfirm
/usr/bin/makepkg -sfc --noconfirm --needed