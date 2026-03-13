#!/bin/bash

echo "[+] Installing base packages..."

sudo apt update

sudo apt install -y \
zsh vim tmux git curl wget unzip \
build-essential \
python3 python3-pip python3-venv \
fonts-jetbrains-mono \
bat fzf fastfetch \
zsh-syntax-highlighting \
zsh-autosuggestions

echo "[+] Installing configs..."

cp .zshrc ~/
cp .vimrc ~/

echo "[+] Importing terminal profile..."

dconf load /org/gnome/terminal/ < gnome-terminal-config.dconf

echo "[+] Done."
