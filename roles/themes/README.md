System
======

an Ansible Role that installs themes on Ubuntu:

Requirements
------------

This role has only been tested on Ubuntu 20.04.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    themes_choice: "Nordic"

The theme version to install.

    themes_gtk_theme_version: "latest"

Whether to configure gtk theme.

    themes_do_configure_gtk_theme: true

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all      
    roles:
        - themes
```

License
-------

MIT / BSD
