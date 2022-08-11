Ranger
======

An Ansible role that installs ranger, and deploys user configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    ranger_dependencies: []

A list of extra packages that ranger might depend on (i.e. due to your custom configs). 

    ranger_configs: []

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
    - role: ranger
      vars:
        ranger_dependencies:
          - dragon
        ranger_configs:
          - "{{ playbook_dir }}/files/ranger"
```

License
-------

MIT / BSD
