Service
=======

A simple Ansible Role that installs services (from pacman) and ensures the given service
configured in user-defined state (disabled, enabled, started, etc.).

Requirements
------------

Arch Linux.

Role Variables
--------------

Available variables are listed below, along with default values (see defaults/main.yml)

    service_packages: []

A list of packages to install. 

    service_name: ""

Name of the service to configure. If left empty, the state of the service will not be configured.

    service_enabled: "yes"

If the service should be enabled on boot.

    service_state: "started"

State of the service (i.e. disabled, enabled, started, etc.).

Dependencies
------------

None

Example Playbook
----------------

```yaml
# Contents of example.yml
- hosts: all
  roles:
    - role: service
      vars:
        service_packages:
            - "network-manager"
            - "network-manager-applet"
        service_name: "NetworkManager"
```

License
-------

MIT / BSD
