Kitty
=====

An Ansible Role that installs Kitty on Linux.

Requirements
------------

This role has only been tested on Ubuntu 20.04.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    kitty_version: ""

The version to install. The version must be specified in X.Y.Z format.

    kitty_install_dest: "{{ ansible_user_dir }}/.local/kitty.app"

Where to install the tarball downloaded from [Kitty Github release page](https://github.com/kovidgoyal/kitty/releases).

    kitty_configs: ""

Path to Kitty configuration files.

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  vars:
    kitty_version: "0.25.2"
    kitty_configs:
      - "{{ playbook_dir }}/files/kitty/kitty.conf"
  roles:
    - kitty
```

License
-------

MIT / BSD
