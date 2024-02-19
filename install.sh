#!/bin/bash

archlinux() {
  echo "Installing yay"
  sudo pacman -S --needed --no-confirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

  sudo yay -Syu --no-confirm hyprland swaylock nvim hyprland wezterm wlogout swappy grim wofi slurp pamixer brightnessctl
  sudo yay -Syu --no-confirm pywal swww ImageMagick flatpak google-chrome neovide-git zsh unzip
  
}

fedora() {
  echo "Sudo is needed"
  sudo dnf install dnf-plugins-core
  # Add hyprland
  sudo dnf copr enable zhanggyb/hyprland
  sudo dnf copr enable alebastr/sway-extras
  sudo dnf copr enable ricclopez/swaylock-effects
  sudo dnf copr enable wezfurlong/wezterm-nightly

  echo "Installing Hyprland and other programs"
  sudo dnf install swaylock-effects neovim hyprland wlogout swappy grim rofi slurp pamixer brightnessctl
  sudo dnf install python3-pip ImageMagick swww flatpak unzip wezterm
}

pywal() {
  pip install pywal
}

sww() {
  ln -sf /home/$USER/.config/swww/dark/fedora_snake.png /home/$USER/.config/swww/wall.dark
  ln -sf /home/$USER/.config/swww/light/jormungandr.jpg /home/$USER/.config/swww/wall.light
  ln -sf /home/$USER/.config/swww/wall.dark /home/$USER/.config/swww/wall.set
}

flatpak() {
  flatpak install flathub com.heroicgameslauncher.hgl
  flatpak install flathub com.librumreader.librum
  flatpak install flathub com.spotify.Client
  flatpak install flathub org.wezfurlong.wezterm
}

ohmyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

fonts() {
  mkdir /home/$USER/.local
  mkdir /home/$USER/.local/fonts
  mkdir /home/$USER/.local/fonts/JetBrainsMono
  cd /home/$USER/.local/fonts/JetBrainsMono

  wget -t0 https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip

  unzip JetBrainsMono.zip
}

config() {

  mkdir /home/$USER/.config
  cp -r ./config/* /home/$USER/.config
  
  sww
  pywal
  flatpak
  ohmyzsh
  fonts
  
}

echo -e "Install config\nyou want continue [y]es or [n]o: "
read CONFIRM

if [[ $CONFIRM == 'y' ]]; then 

  if [[ $(grep "^NAME=\"Arch" /etc/os-release) ]]; then
    echo "System: Arch linux"
    archlinux
  fi

  if [[ $(grep "^NAME=\"Fedora" /etc/os-release) ]]; then
    echo "System: Fedora"
    fedora
  fi

  echo "Preparing the other programs"
  config
fi


