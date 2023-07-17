Package
=======

An Ansible role for bootstrapping Arch Linux from an iso installation medium.

Requirements
------------

Arch Linux.

Role Variables
--------------

TODO
- ext4 vs btrfs?

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  roles:
    - role: package
      vars:
        package_name: bash
        package_configs:
          - src: "{{ ansible_user_dir }}/files/bash/"
            dest: "{{ ansible_user_dir }}"

```

License
-------

MIT / BSD
