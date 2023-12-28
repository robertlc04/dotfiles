#!/bin/bash

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
fi

archlinux() {
  echo "Installing yay"
  sudo pacman -S --needed --no-confirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

  sudo yay -Syu --no-confirm hyprland swaylock nvim hyprland wezterm wlogout swappy grim wofi slurp pamixer brightnessctl
  sudo yay -Syu --no-confirm pywal swww ImageMagick flatpak google-chrome
  
}

fedora() {
  echo "Sudo is needed"
  sudo dnf install dnf-plugins-core
  # Add hyprland
  sudo dnf copr enable zhanggyb/hyprland
  sudo dnf copr enable alebastr/sway-extras

  echo "Installing Hyprland and other programs"
  sudo dnf install swaylock nvim hyprland wezterm wlogout swappy grim wofi slurp pamixer brightnessctl
  sudo dnf install python3-pip ImageMagick swww flatpak
}

config() {

  mkdir /home/$USER/.config
  cp -r ./config/* /home/$USER/.config
  
  sww
  pywal
  
}

pywal() {
  pip install pywal
}

sww() {
  ln -sf /home/$USER/.config/swww/dark/fedora_snake.png /home/$USER/.config/swww/wall.dark
  ln -sf /home/$USER/.config/swww/light/jormungandr.jpg /home/$USER/.config/swww/wall.light
  ln -sf /home/$USER/.config/swww/wall.dark /home/$USER/.config/swww/wall.set
}
