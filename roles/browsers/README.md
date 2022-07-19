Browsers
========

an Ansible Role that installs the following browsers on Ubuntu:
- [Chromium](https://www.chromium.org)

Requirements
------------

This role has only been tested on Ubuntu 20.04.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    browsers_chromium_do_install: false

Whether or not to install Chromium.

Dependencies
------------

None

Example Playbook
----------------

    - hosts: all
      
      vars:
        browsers_chromium_do_install: true
      
      roles:
         - browsers

It's possible to filter what browsers are installed as part of the role by specifying tags during call to ansible-playbook. The following example will only install Chromium provided the default `browsers_chromium_do_install` is set to `true`.

    ansible-playbook example.yml --tags "chromium" -K

This is useful if you have enabled installation of multiple browsers, but only want to run specific tasks within this role.

License
-------

MIT / BSD
