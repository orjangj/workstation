Bootstrap
=========

Arch Linux provides several methods [1] for installing Arch on a target machine. The following document
describes the method of installing Arch Linux via SSH [2].

Installing Arch Linux on a machine using SSH requires some preparation:

1. Prepare the installation medium
2. Bootstrap target machine using `bootstrap.yml` playbook

After boostrap, the machine can be further provisionined using the `converge.yml` playbook.

Prepare installation medium
---------------------------

There are two methods available for installing Arch Linux via SSH:

* Manual setup on target machine with password-based root user access,
* Headless setup using cloud-init NoCloud to automatically configure OpenSSH authorized keys and iwd connections.

This document outlines the preparations needed to setup a headless configuration (which is preferred when using ansible for provisioning).

Prepare cloud-init configuration files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two required cloud-init configuration files: `meta-data` and `user-data`.

The `meta-data` file can be empty:

```bash
$ printf "" > meta-data
```

The `user-data` file will contain relevant configuration to initialize OpenSSH authorized keys and iwd connection.
The contents of `user-data` should contain the following information:

```
#cloud-config
users:
  - name: root
    ssh_authorized_keys:
      - ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

write_files:
- content: |
    [Security]
    PreSharedKey=aafb192ce2da24d8c7805c956136f45dd612103f086034c402ed266355297295
  path: /var/lib/iwd/spaceship.psk
```

Remember to:

* Replace the content of `ssh-authorized_keys` with the public SSH key used for connecting to target via SSH.
* Replace `PreSharedKey` and `spaceship` with the appropriate key and SSID.

The preshared key can be calculated using i.e. `wpa_passhprase`:

```bash
$ wpa_passhprase "SSID"
> promt for passhprase

# output
network={
	ssid="test"
	#psk="test1234"
	psk=e1d15cf7adfa02e7d7a61606ebfa5ee4ac3fe3b23fc6cdb6afbd9d5cba19df9c
}
```

Copy the content of `psk` and append to `PreSharedKey=`.

Create a cloud-init.iso file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following packages must be installed on the host doing the repackaging of the Arch Linux ISO file:

* dosfstools
* mtools
* xorriso (i.e. via libisoburn)

First create a FAT image with its label set to CIDATA:

```bash
$ mkfs.fat -C -n CIDATA cloud-init.img 2048
```

Copy the `meta-data` and `user-data` to the root of it:

```bash
$ mcopy -i cloud-init.img meta-data user-data ::
```

Repack the official ISO to include the FAT image as a third partition:

```bash
$ xorriso -indev archlinux-version-x86_64.iso -outdev archlinux-version-x86_64-with-cidata.iso -append_partition 3 0x0c cloud-init.img -boot_image any replay
```

Remember to replace `version` to the correct version of the preferred Arch Linux ISO.

From this point on, the `archlinux-version-x86_64-with-cidata.iso` can be used as an ISO image for i.e. Virtualbox, or be burned to a USB Flash medium that can be
inserted into the target machine. Once the target machine boots into the live environment it should be possible to connect to the target machine using the SSH key
corresponding to the public SSH key provisioned in the `user-data` configuration file.

To burn the USB Flash drive:

```bash
dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/sdx conv=fsync oflag=direct status=progress
```

Run the bootstrap playbook
--------------------------

The purpose of the bootstrap playbook is to:

* partition
* enable encrypted filesystem
* install base packages
* Setup user
* ...

See [Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide) for more information.


Resources
---------

[1] - https://wiki.archlinux.org/title/Category:Installation_process
[2] - https://wiki.archlinux.org/title/Install_Arch_Linux_via_SSH

