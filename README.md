# Workstation

Ansible-based provisioning for a Hyprland development workstation. Takes a minimal Arch Linux or Fedora install to a fully working desktop environment with development tools, theming, and system services configured.

## Supported Distributions

- Arch Linux
- Fedora

## Prerequisites

A minimal install of Arch Linux or Fedora with a user account and network access. DNF parallel downloads and fastest mirror are configured automatically by the playbook.

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
| hardware | Base hardware support (firmware, sensors, diagnostics) |
| network | NetworkManager and applet |
| bluetooth | BlueZ bluetooth stack |
| audio | PipeWire audio stack with ALSA, PulseAudio compatibility, and media controls |
| gpu | Auto-detect GPU vendor (Intel/AMD/NVIDIA) and install drivers |
| firewall | firewalld |
| storage | SSD TRIM timer and zram compressed swap |
| power | Power profile management (power-profiles-daemon / tuned) |
| hyprland | Hyprland compositor with ecosystem tools (hypridle, hyprlock, hyprpaper, waybar, wofi, etc.) |
| terminal | Terminal emulators (kitty, foot) and shell configuration (bash/zsh) |
| virtualization | QEMU/KVM with virt-manager, Vagrant, Podman, quickemu |
| devtools | C/C++ and embedded development tools |
| neovim | Neovim (package or source install) |
| nerdfonts | Nerd Font families |
| lazygit | Build lazygit from source |
| dotfiles | Deploy dotfiles via bare git repository |
| theming | Nordic GTK/Qt themes, Nordzy icons and cursors, Breeze SDDM theme, wallpapers |
| polkit | polkit authentication agent |
| xdg | XDG desktop portals and user directories |
| sddm | SDDM display manager with Hyprland session |
| renode | Renode hardware simulation framework |

## Configuration

Global configuration lives in two files under `vars/`:

- **`vars/packagegroups.yml`** — Distribution-specific and common packages
- **`vars/configs.yml`** — Pinned tool versions, dotfiles repo URL, wallpaper sources, theme versions

Role defaults can be overridden in `vars/configs.yml`. For example:

```yaml
lazygit_version: "v0.59.0"
nerdfonts_version: "v3.4.0"
theming_nordzy_cursors_version: "v2.4.0"
```

## Testing

The project includes a Vagrantfile for testing in a VM using the libvirt provider.

```bash
# Spin up a Fedora VM (default)
VM_DISTRO=fedora vagrant up

# Spin up an Arch Linux VM
VM_DISTRO=archlinux vagrant up

# Run specific roles
TAGS=gpu,theming,sddm vagrant provision

# Enable verbose output
VERBOSE=v vagrant up

# Launch graphical console
DISPLAY_CONSOLE=1 vagrant up

# Tear down
vagrant destroy
```

The VM automatically uses half the host's RAM and CPU cores, with a 40GB disk and SPICE graphics.
