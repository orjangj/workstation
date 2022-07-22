Foot
====

An Ansible Role that installs foot terminal emulator on Linux.

Requirements
------------

Currently only installs on Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    foot_configs: ""

Path to foot configuration directory. The directory should at the very least include a foot.ini file.
The contents of the configuration directory will be copied to `~/.config/foot`.

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  vars:
    foot_configs: "{{ playbook_dir }}/files/foot"
  roles:
    - foot
```

License
-------

MIT / BSD
