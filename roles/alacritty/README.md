Kitty
=====

an Ansible Role that installs Alacritty on Ubuntu:

Requirements
------------

This role has only been tested on Ubuntu 20.04.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    alacritty_version: "latest"

The version to install.

    alacritty_config: ""

Path to the alacritty.yml configuration file.

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all      
    roles:
        - alacritty
```

License
-------

MIT / BSD
