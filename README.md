# Workstation

Ansible-based provisioning for a Hyprland development workstation. Takes a minimal Arch Linux or Fedora install to a fully working desktop environment with development tools, theming, and system services configured.

## Supported Distributions

- Arch Linux
- Fedora

## Prerequisites

A minimal install of Arch Linux or Fedora with a user account and network access.

**Fedora (optional):** Speed up package downloads by adding to `/etc/dnf/dnf.conf`:

```
max_parallel_downloads=10
```

## Quick Start

1. **Bootstrap** (installs Ansible and minimal dependencies):

   ```bash
   bash bootstrap.sh
   ```

2. **Run full provisioning**:

   ```bash
   ansible-playbook converge.yml
   ```

3. **Reboot** to start SDDM and log into Hyprland.

## Usage

Run specific roles using tags:

```bash
ansible-playbook converge.yml --tags neovim
ansible-playbook converge.yml --tags network,audio,theming
```

## Project Structure

```
converge.yml              Main playbook
bootstrap.sh              First-time setup script
ansible.cfg               Ansible configuration
inventory                 Localhost inventory
Vagrantfile               VM testing configuration
vars/
  packagegroups.yml       Distribution-specific packages
  configs.yml             Pinned versions and configuration
roles/
  <role>/
    tasks/main.yml        Role tasks
    vars/main.yml         Role-internal variables (packages, etc.)
    defaults/main.yml     User-overridable defaults
```

## Roles

| Role | Description |
|------|-------------|
| network | NetworkManager and applet |
| bluetooth | BlueZ bluetooth stack |
| audio | PipeWire audio stack with ALSA, PulseAudio compatibility, and media controls |
| gpu | Auto-detect GPU vendor (Intel/AMD/NVIDIA) and install drivers |
| firewall | firewalld |
| storage | SSD TRIM timer and zram compressed swap |
| power | Power profile management (power-profiles-daemon / tuned) |
| bash | Set bash as default shell |
| libvirt | QEMU/KVM virtualization with virt-manager |
| neovim | Build Neovim from source |
| nerdfonts | Nerd Font families |
| lazygit | Build lazygit from source |
| dotfiles | Deploy dotfiles via bare git repository |
| stylua | Lua formatter for Neovim |
| theming | Nordic GTK/Qt themes, Nordzy icons and cursors, SDDM theme, wallpapers |
| polkit | polkit-gnome authentication agent |
| xdg | XDG desktop portals and user directories |
| sddm | SDDM display manager with Hyprland session |
| renode | Renode hardware simulation framework |

## Configuration

Global configuration lives in two files under `vars/`:

- **`vars/packagegroups.yml`** — Distribution-specific and common packages
- **`vars/configs.yml`** — Pinned tool versions, dotfiles repo URL, wallpaper sources, theme versions

Role defaults can be overridden in `vars/configs.yml`. For example:

```yaml
neovim_version: "v0.11.6"
nerdfonts_version: "v3.4.0"
theming_nordic_version: "v2.2.0"
```

## Testing

The project includes a Vagrantfile for testing in a VM using the libvirt provider.

```bash
# Spin up a Fedora VM (default)
VM_DISTRO=fedora vagrant up

# Spin up an Arch Linux VM
VM_DISTRO=archlinux vagrant up

# Run specific roles
VM_DISTRO=fedora TAGS=gpu,theming,sddm vagrant up

# Enable verbose output
VERBOSE=v vagrant up

# Tear down
vagrant destroy
```

The VM is configured with 8GB RAM, 4 CPUs, and SPICE graphics. `virt-viewer` is launched automatically for graphical console access.

