Package
=======

A simple Ansible Role that installs pacman packages and deploys user
configuration files on Arch Linux.

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    package_name: []

A list of packages to install 

    package_configs: []

A list of configuration files to deploy. Each element in the list must be a dict with
fields `src` (where to copy from) and `dest` (optional, where to copy to). By default,
the configuration files/directories are copied to `{{ ansible_user_dir }}/.config`
directory on the remote host.

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
