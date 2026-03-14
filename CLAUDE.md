# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ansible-based Linux workstation provisioning. Automates setup of a complete Hyprland development and desktop environment on Arch Linux and Fedora.

## Commands

**Bootstrap (bare system first-time setup):**
```bash
bash bootstrap.sh
```

**Run full provisioning:**
```bash
ansible-playbook converge.yml
```

**Run specific roles using tags:**
```bash
ansible-playbook converge.yml --tags neovim
ansible-playbook converge.yml --tags network,audio,terminal
```

**Test in a VM (Vagrant + libvirt):**
```bash
VM_DISTRO=fedora vagrant up           # Fedora VM (default)
VM_DISTRO=archlinux vagrant up        # Arch Linux VM
TAGS=neovim VERBOSE=v vagrant provision  # specific tags, verbose
DISPLAY_CONSOLE=1 vagrant up          # graphical console
vagrant destroy                       # tear down
```

## Architecture

### Playbook Structure

`converge.yml` is the main playbook. It:
1. Gathers system facts
2. Optimizes DNF configuration (Fedora)
3. Installs distribution-specific base packages from `vars/packagegroups.yml`
4. Executes roles in sequence (each role has a tag matching its name)
5. Clones personal git projects as a post-provision step

### Global Variables

- `vars/packagegroups.yml` — Distribution-specific package lists keyed by `ansible_distribution` (Archlinux, Fedora) plus a `common` list
- `vars/configs.yml` — Tool versions (lazygit, renode, nerdfonts), dotfiles repo URL, wallpaper sources, theme versions

### Roles

Each role lives in `roles/<name>/` with standard Ansible structure (`tasks/main.yml`, optional `defaults/` and `vars/`). Active roles in the playbook: hardware, network, bluetooth, audio, gpu, firewall, storage, power, hyprland, terminal, virtualization, devtools, neovim, nerdfonts, lazygit, dotfiles, theming, polkit, xdg, sddm, renode.

### Key Patterns

- **Multi-distro support**: Tasks use `ansible.builtin.package` for distro-agnostic installs; conditional logic uses `ansible_distribution`
- **Self-contained roles**: Each role owns all its packages and dependencies
- **COPR fallback**: Hyprland role tries official repos first, falls back to COPR on Fedora
- **Source compilation**: Some tools (neovim, lazygit) can optionally be built from source and installed to `~/.local/`
- **User-aware paths**: Uses `ansible_user_dir` and `ansible_user_id`; distinguishes vagrant test users from real users for git clone URLs (HTTPS vs SSH)
- **Idempotent tasks**: All tasks designed to be safely re-run
- **Variable namespacing**: Role variables are prefixed with `<role_name>_`

### Ansible Configuration

`ansible.cfg` sets roles path to `roles`, inventory to `inventory` (localhost), and enables SSH pipelining.

### VM Testing

The `Vagrantfile` uses the libvirt provider with half host RAM/CPUs, 40GB disk, and SPICE graphics. Default distro is Fedora; override with `VM_DISTRO` env var. Set `DISPLAY_CONSOLE=1` to launch virt-viewer. Set `TAGS` to run specific roles.
