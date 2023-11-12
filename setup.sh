#!/usr/bin/env bash
# update default packages and refresh repositories
sudo dnf update -y

# add rpm fusion repositories
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# install multimedia codecs 
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# add vs code repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# install assorted packages
sudo dnf install -y kitty krita zsh util-linux-user code steam libinput-devel meson ninja-build systemd-devel gnome-shell-extension-just-perfection gnome-shell-extension-dash-to-dock pop-icon-theme neofetch python3-pip nautilus-python kvantum gnome-tweaks mesa-freeworld

# add flathub and install flatpak packages
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord com.plexamp.Plexamp com.mattjakeman.ExtensionManager org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

# install gnome extensions not available in repos
pip3 install gnome-extensions-cli
gnome-extensions-cli install 5489

# disable activities hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

# set up just perfection
gsettings set org.gnome.shell.extensions.just-perfection activities-button false
gsettings set org.gnome.shell.extensions.just-perfection window-demands-attention-focus true
gsettings set org.gnome.shell.extensions.just-perfection startup-status 0

# set up dash to dock
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
gsettings set org.gnome.shell.extensions.dash-to-dock background-color 'rgb(25,25,25)'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC'

gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'kitty.desktop', 'code.desktop', 'steam.desktop', 'com.discordapp.Discord.desktop', 'org.kde.krita.desktop', 'com.plexamp.Plexamp.desktop']"

# install and enable adw-gtk3 theme and system dark mode
sudo dnf copr enable nickavem/adw-gtk3
sudo dnf install adw-gtk3

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# set icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Pop'

# misc. gnome settings
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# gnome files settings
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

# set nautilus to open kitty instead of gnome-terminal
sudo pip install setuptools
pip3 install --user nautilus-open-any-terminal
nautilus -q
glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true

# set kvantum theme for qt5 applications
git clone https://github.com/GabePoel/KvLibadwaita.git
cp -r ~/KvLibadwaita/src/KvLibadwaita ~/.config/Kvantum
kvantummanager --set KvLibadwaitaDark

rm -rf ~/KvLibadwaita

# set up libinput-config to reduce scroll speed
git clone https://gitlab.com/warningnonpotablewater/libinput-config.git
cd libinput-config
meson build
cd build
ninja
sudo ninja install

cd ~
rm -rf ~/libinput-config

echo "scroll-factor=0.35" | sudo tee -a /etc/libinput.conf

# copy assorted dotflies and etc.
mkdir ~/.local/share/applications
cp ~/kateFedora/applications/* ~/.local/share/applications/
cp -r ~/kateFedora/config/* ~/.config
mkdir ~/Pictures/Wallpapers
cp ~/kateFedora/wallpapers/* ~/Pictures/Wallpapers/
mkdir .fonts
cp ~/kateFedora/fonts/* ~/.fonts/

# set wallpaper
gsettings set org.gnome.desktop.background picture-uri-dark file:///home/kateulator/Pictures/Wallpapers/fuitgummy.png

# change shell to zsh
chsh -s /bin/zsh

# install oh-my-zsh and powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp ~/kateFedora/.zshrc ~/

echo "All Done!! Close the terminal and open Kitty to finish setup"
