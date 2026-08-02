#/bin/bash

comand = 'pacman -Syu'
apps = (
    "ghostty"
    "hyprland"
    "hyprpaper"
    "mako"
    "neovim"
    "opencode"
    "waybar"
)


for app in $(apps[@]); do
    sudo $command $app
