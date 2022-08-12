Sway
====

An Ansible Role that installs a Sway Window Manager, its dependencies, and deploys user configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    sway_dependencies: []

A list of extra packages that the Sway might depend on (i.e. due to your custom configs). 

    sway_configs: []

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
    - role: sway
      vars:
        awesome_dependencies:
          - wofi
          - alacritty
        awesome_configs:
          - "{{ playbook_dir }}/files/sway"
          - "{{ playbook_dir }}/files/wofi"
          - "{{ playbook_dir }}/files/alacritty"
```

License
-------

MIT / BSD
