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
    
    emerge gnome-base/gnome app-arch/file-roller gnome-base/dconf-editor gnome-extra/gnome-calculator gnome-extra/gnome-system-monitor gnome-extra/gnome-tweaks gnome-extra/gnome-weather sys-apps/gnome-disk-utility sys-apps/baobab gnome-extra/gnome-shell-extensions app-eselect/eselect-gnome-shell-extensions
  
    emerge media-libs/openal
}

install_audio () {
    echo "media-video/pipewire pipewire-alsa sound-server systemd dbus X bluetooth" > /etc/portage/package.use/pipewire
    echo "media-video/wireplumber systemd" /etc/portage/package.use/wireplumber
    echo "media-libs/libcanberra gtk3" > /etc/portage/package.use/libcanberra
    emerge media-video/pipewire media-video/wireplumber media-libs/libcanberra
}

install_flatpak () {
    emerge sys-apps/flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    emerge sys-apps/xdg-desktop-portal sys-apps/xdg-desktop-portal-gnome sys-apps/xdg-desktop-portal-gtk
}

install_applications () {
    echo "x11-terms/alacritty wayland" > /etc/portage/package.use/alacritty
    emerge x11-terms/alacritty
    emerge app-eselect/eselect-repository
    eselect repository enable gentoo-zh
    emaint sync
    emerge www-client/thorium-browser-bin

    echo "app-editors/emacs gtk -X gui inotify dbus gfile jpeg png svg webp json threads harfbuzz tree-sitter jit sound dynamic-loading" > /etc/portage/package.use/emacs
    emerge app-editors/emacs app-emacs/vterm app-emacs/nerd-icons

    echo "dev-vcs/git curl gpg iconv nls pcre perl highlight keyring" > /etc/portage/package.use/git
    emerge dev-vcs/git dev-vcs/gitg
    git config --global user.email "matty_ice_2011@pm.me"
    git config --global user.name "mattyice"
    
}

main () {
    rm /stage3-*.tar.*
       
    install_gnome
    install_audio
    install_flatpak
    install_sudo
    create_user
    install_applications

    systemctl enable gdm
    echo -e "${RED}!!! Reminder: Type /"visudo/" command to uncomment wheel line!\n!!! Reminder: config systemd to enable audio${RESET}"
    # systemctl --user disable pulseaudio.service pulseaudio.socket
    # systemctl --user disable pipewire-media-session.service
    # systemct --user enable --now pipewire.socket pipewire-pulse.socket
    # systemct --user enable --now wireplumber.service
    # switch to root -- execute visudo

    reboot
}
