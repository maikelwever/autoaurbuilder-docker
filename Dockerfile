FROM logankoester/archlinux
MAINTAINER Maikel Wever <maikelwever@gmail.com>

# Adding mirrorlist with Dutch servers for when I build locally
# Doesn't matter much on Docker Hub
ADD mirrorlist /etc/pacman.d/mirrorlist

RUN pacman -Sy --noconfirm && \
    pacman -S archlinux-keyring --noconfirm && \
    pacman -Su --noconfirm
RUN pacman -S --noconfirm base-devel sudo

VOLUME /build
WORKDIR /build

ADD sudoers /etc/sudoers
# Set up user & sudo
RUN useradd -d /build -G wheel build && \
    chmod 0400 /etc/sudoers

# Copy over buildscript
ADD buildscript.sh /opt/buildscript.sh

USER build

# Options: Install dependencies, force package build, clean afterwards
ENTRYPOINT sudo chown build: /build && \
           bash /opt/buildscript.sh
