Kitty
=====

An Ansible role that installs kitty terminal emulator, and deploys user configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    kitty_dependencies: []

A list of extra packages that kitty might depend on (i.e. due to your custom configs). 

    kitty_configs: []

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
    - role: kitty
      vars:
        kitty_configs:
          - "{{ playbook_dir }}/files/kitty"
```

License
-------

MIT / BSD
