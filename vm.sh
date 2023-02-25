#!/usr/bin/bash

# This is a convenience script to attach virt-viewer on `vagrant up` and close it
# on `vagrant halt|destroy`. Simply because vagrant itself doesn't have the means
# (to my knowledge) to auto attach a viewer (for KVM/QEMU/Libvirt) when bringing
# up the VM (like gui for VirtualBox).

if [ -z "$VM_ENV" ]; then
    echo "Please source vm-init-env before calling this script." >&2
    exit 1
fi

case "$1" in
  up)
    virt-viewer --connect "${VM_URI}" --wait --attach "${VM_ATTACH}" &
    vagrant up
  ;;
  destroy)
    # Tired of vagrant prompting for yes/no
    vagrant destroy -f
  ;;
  view)
    # In case there's problems with viewer during vagrant up
    virt-viewer --connect "${VM_URI}" --attach "${VM_ATTACH}" &
  ;;
  *)
    # Just pass everything else to vagrant
    vagrant "$1"
  ;;
esac
