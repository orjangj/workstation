# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ansible-based Linux workstation provisioning. Automates setup of a complete development and desktop environment on Arch Linux and Fedora.

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
ansible-playbook converge.yml --tags network,audio,bash
```

**Test in a VM with Vagrant (libvirt provider):**
```bash
VM_DISTRO=fedora vagrant up        # also: archlinux
VM_DISTRO=fedora TAGS=neovim vagrant up  # run specific tags
VERBOSE=v vagrant up               # verbose output
vagrant destroy
```

## Architecture

### Playbook Structure

`converge.yml` is the main playbook. It:
1. Gathers system facts
2. Installs distribution-specific base packages from `vars/packagegroups.yml`
3. Executes roles in sequence (each role has a tag matching its name)
4. Clones personal git projects as a post-provision step

### Global Variables

- `vars/packagegroups.yml` — Distribution-specific package lists keyed by `ansible_distribution` (Archlinux, Fedora) plus a `common` list
- `vars/configs.yml` — Tool versions (neovim, lazygit, renode), dotfiles repo URL, wallpaper sources

### Roles

Each role lives in `roles/<name>/` with standard Ansible structure (`tasks/main.yml`, optional `defaults/` and `vars/`). Active roles in the playbook: network, bluetooth, audio, gpu, firewall, bash, libvirt, neovim, nerdfonts, lazygit, dotfiles, stylua, theming, polkit, xdg, sddm, renode.

### Key Patterns

- **Multi-distro support**: Tasks use `ansible.builtin.package` for distro-agnostic installs; conditional logic uses `ansible_distribution`
- **Source compilation**: Some tools (neovim, lazygit) are built from source and installed to `~/.local/`
- **User-aware paths**: Uses `ansible_user_dir` and `ansible_user_id`; distinguishes vagrant test users from real users for git clone URLs (HTTPS vs SSH)
- **Idempotent tasks**: All tasks designed to be safely re-run

### Ansible Configuration

`ansible.cfg` sets roles path to `roles`, collections path to `./`, and inventory to `inventory` (localhost).

### Vagrant Testing

The `Vagrantfile` uses libvirt provider with 8GB RAM / 4 CPUs, SPICE graphics, and auto-launches `virt-viewer` for graphical console. Default distro is fedora; override with `VM_DISTRO` env var. Default tags is `never` (no roles run unless `TAGS` is specified).
