#!/usr/bin/bash

CYAN='\e[1;36m'
GREEN='\e[1;32m'
RED='\e[1;31m'
RESET='\e[0m'

create_user () {
    useradd -m -G users,wheel,audio,pipewire,video,usb -s /bin/bash mattyice
    passwd mattyice
}

install_sudo () {
    # TODO: Use awk and sed to uncomment wheel line
    emerge app-admin/sudo
}

install_gnome () {
    echo "gnome-base/gnome -extras" > /etc/portage/package.use/gnome
    echo "media-video/pipewire" > /etc/portage/package.use/pipewire
    emerge gnome-base/gnome app-arch/file-roller gnome-base/dconf-editor gnome-extra/gnome-calculator gnome-extra/gnome-system-monitor gnome-extra/gnome-tweaks gnome-extra/gnome-weather sys-apps/gnome-disk-utility sys-apps/baobab
    systemctl enable --now gdm
    emerge video-media/pipewire video-media/wireplumber
    systemctl --user enable --now pipewire-pulse.socket wireplumber-service
    systemctl --user enable --now pipewire.service
    emerge media-libs/openal
}

install_flatpak () {
    emerge sys-apps/flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    emerge sys-apps/xdg-desktop-portal sys-apps/xdg-desktop-portal-gnome sys-apps/xdg-desktop-portal-gtk
    echo "gnome-extra/gnome-software flatpak" > /etc/portage/package.use/gnome-software
    echo "gnome-extra/gnome-software ~amd64" > /etc/portage/package.use/gnome-software
    emerge gnome-extra/gnome-software
}

main () {
    rm /stage3-*.tar.*
    # need to switch gentoo profile to gnome
    create_user
    install_sudo
    install_gnome
    install_flatpak
    

    echo -e "${RED}!!! Reminder: Type /"visudo/" command to uncomment wheel line!${RESET}"
}
