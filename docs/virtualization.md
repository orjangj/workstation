# Virtualization

This article is mostly considering QEMU/KVM as it's better suited for Linux.

## System requirements

The system requirements may depend on the guest operating system, but in general you should have:

- At least 3GB of disk storage per guest for modern desktop environments.
- At least 756MB or RAM per guest of a modern operating system.

In most cases, however, you'll have to allocate more than the bare minimum to have a good
experience.

In addition to the system requirements, you'll need to ensure virtualization is enabled in firmware
before you can use the virtualization tools.

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

This command works for both Intel processor (vmx) and for the AMD processor (svm). The command is
simply a count of the amount of times the given expression (either vmx or svm) is detected. The file
`/proc/cpuinfo` holds information about your CPU regardless of what Linux distribution you're on. If
the number displayed by the command is greater than `0`, then you're all set and good to go. If the
number is `0`, then you'll have to enter the BIOS/UEFI during early boot to enable virtualization
support. Entering BIOS/UEFI can normally be achieved by pressing `F2` (repeatedly, so you don't miss
the time-window) or one of the other `F#`. The correct key might depend on what model and/or make of
your computer.

> Even if your processor does not support the relevant virtualization extensions in firmware, you
> can still use i.e. QEMU/KVM. The emulator will, however, fall back to software virtualization
> which is much slower.

## KVM

KVM is a type 1 hypervisor that is well integrated with the Linux Kernel, and will give you close to
bare-metal performance. It's open-source and free to use, and it's smaller and faster than i.e.
VirtualBox (a type 2 hypervisor). It has support for USB and GPU redirect. If your host is running
Linux, then it's generally better to use KVM although VirtualBox (or other hypervisors) may be more
scalable and/or portable.

### Installing the virtualization software

On Fedora, you can simply install the required packages through the `@virtualization` package group:

```bash
sudo dnf install @virtualization  # Mandatory and default packages
sudo dnf group install --with-optional virtualization  # With optional packages included
```

On Debian/Ubuntu, you'll have to pick the preferred packages personally (preferably precisely, and
possibly perfectly):

```bash
sudo apt-get install virt-manager libvirt-bin qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
```

And on Arch Linux:

```bash
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables
```

Some important packages:

- `qemu-kvm`: QEMU is the emulator itself, and the `qemu-kvm` package contains the main bits and
  pieces the operating system will need to do virtualization with KVM.
- `libvirt-daemon`: The daemon is **very** important as it's the service that will run
  virtualization in the background.
- `bridge-utils`: Contains vital networking dependencies.

Additionally, `virt-manager` ([Virtual Machine Manager](https://virt-manager.org)) is useful in case
you want a graphical program that can be used to work with the virtual machines. Alternatively, you
can do a lot of useful work using the `virsh` CLI tool.

### Enable normal user account to use KVM

Usually, you'll have sort out group memberships to work with the virtualization tools:

```bash
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)
```

### libvirt-daemon

Make sure the daemon is started end enabled on boot.

```bash
sudo systemctl start libvirtd  # Start the daemon immediately
sudo systemctl enable libvirtd  # Ensure it starts automatically on next boot
```

To verify the service is running in the background:

```bash
sudo systemctl status libvirtd
```

To verify that the KVM kernel modules are properly loaded:

```bash
lsmod | grep kvm
```

### Now what?

You'll need to download an ISO file on which the VM can be based on. Or if you want to go crazy, you
can look into using Vagrant or QuickEMU to easily get something up and running (without having to
think about downloading those ISO files manually).

## Resources

- [Fedora](https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-virtualization/)
