Awesome
=======

An Ansible Role that installs a Awesome Window Manager, its dependencies, and deploys user configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    awesome_dependencies: []

A list of extra packages that the Awesome might depend on (i.e. due to your custom configs). 

    awesome_configs: []

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
    - role: awesome
      vars:
        awesome_dependencies:
          - rofi
          - alacritty
        awesome_configs:
          - "{{ playbook_dir }}/files/awesome"
          - "{{ playbook_dir }}/files/rofi"
          - "{{ playbook_dir }}/files/alacritty"
```

License
-------

MIT / BSD
