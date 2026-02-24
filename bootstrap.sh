#!/bin/bash

distro=$(. /etc/os-release && echo "$ID")

case $distro in
  archlinux)
    sudo pacman -S ansible git github-cli python vim
    ;;
  fedora)
    sudo dnf install ansible gh git python3
    ;;
esac

