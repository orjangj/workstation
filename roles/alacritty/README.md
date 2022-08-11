Alacritty
=========

An Ansible role that installs alacritty terminal emulator, and deploys user configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    alacritty_dependencies: []

A list of extra packages that alacritty might depend on (i.e. due to your custom configs). 

    alacritty_configs: []

A list of configuration files to deploy. The list can also include configs of extra packages.

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  roles:
    - role: alacritty
      vars:
        alacritty_configs:
          - "{{ playbook_dir }}/files/alacritty"
```

License
-------

MIT / BSD
