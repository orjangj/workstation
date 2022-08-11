SDDM
====

An Ansible Role that installs SDDM display manager (login manager), extra user-specified
dependencies, and user-specified configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    sddm_dependencies: []

A list of extra packages that SDDM might depend on (i.e. due to your custom configs). 

    sddm_configs: []

A list of configuration files to deploy. The list can also include configs of extra packages.

    sddm_enable: true

Whether to enable SDDM to start on boot.

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  roles:
    - role: sddm
      vars:
        sddm_configs:
          - "{{ playbook_dir }}/files/sddm"
```

License
-------

MIT / BSD
