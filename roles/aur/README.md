Aur
===

An Ansible Role that installs AUR helper and packages.

Requirements
------------

Distro: Arch Linux
Packages: git

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    aur_helper: "paru"

The AUR helper to install/use.

    aur_helper_clone_path: "{{ ansible_user_dir }}"

Where to clone `aur_helper`.

    aur_packages: ""

List of AUR packages to install using `aur_helper`.

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  vars:
    aur_helper: "paru"
    aur_packages:
      - nordic-wallpapers
  roles:
    - aur
```

License
-------

MIT / BSD
