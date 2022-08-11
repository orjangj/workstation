Foot
====

An Ansible role that installs foot terminal emulator, and deploys user configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    foot_dependencies: []

A list of extra packages that foot might depend on (i.e. due to your custom configs). 

    foot_configs: []

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
    - role: foot
      vars:
        foot_configs:
          - "{{ playbook_dir }}/files/foot"
```

License
-------

MIT / BSD
