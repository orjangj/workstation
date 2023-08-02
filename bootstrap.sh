#!/bin/bash

distro=$(uname -a | awk '{print $2}')

case $distro in
  archlinux)
    sudo pacman -S ansible git github-cli python vim
    ;;
  fedora)
    sudo dnf install ansible gh git python3
    ;;
  debian)
    sudo apt update && sudo apt install ansible gh git python3
    ;;
esac

