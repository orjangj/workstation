# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

distro = ENV['VM_DISTRO'] || "fedora"
playbook = ENV['PLAYBOOK'] || "converge.yml"
tags = ENV['TAGS'] || "never"
display = ENV['DISPLAY_CONSOLE'] || false

host_memory = `grep MemTotal /proc/meminfo`.split[1].to_i / 1024
host_cpus = `nproc`.to_i

# 3D acceleration (SPICE GL) needs a render node QEMU can use. Without one set,
# libvirt takes the first /dev/dri/renderD* it finds; on hybrid laptops that can
# be the NVIDIA GPU, whose EGL fails inside the libvirt sandbox (EGL_NOT_INITIALIZED).
# Pick the first render node not driven by nvidia (Intel/AMD, Mesa).
render_node = Dir.glob("/sys/class/drm/renderD*").sort.map { |n|
  driver = File.join(n, "device", "driver")
  [File.basename(n), File.exist?(driver) ? File.basename(File.realpath(driver)) : nil]
}.find { |_, driver| driver && driver != "nvidia" }&.first
render_node &&= "/dev/dri/#{render_node}"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vagrant.plugins = "vagrant-libvirt"
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  case distro
  when "archlinux"
    config.vm.define :archlinux do |archlinux|
      config.vm.box = "archlinux/archlinux"
    end
    # Ensure python3 is installed before running ansible provisioner
    config.vm.provision "shell", inline: "pacman -Syy --needed --noconfirm python3"
  when "fedora"
    config.vm.define :fedora do |fedora|
      config.vm.box = "fedora/43-cloud-base"
      config.vm.box_url = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Vagrant-libvirt-43-1.6.x86_64.vagrant.libvirt.box"
    end
  end

  config.vm.hostname = distro

  # REF: https://vagrant-libvirt.github.io/vagrant-libvirt/configuration.html
  config.vm.provider :libvirt do |v|
    # See https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html#qemu-session-support
    #v.qemu_use_session = true  # If set, v.uri is qemu:///session, else uri is qemu:///system
    v.machine_virtual_size = 40  # GB
    v.memory = host_memory / 2
    v.cpus = host_cpus / 2
    v.cpu_mode = "host-passthrough"
    v.disk_bus = "virtio"
    v.disk_driver :cache => "writeback", :io => "threads"
    v.graphics_type = "spice"
    v.video_type = "virtio"

    # vagrant-libvirt has no render node option, see the StartDomain trigger below
    v.video_accel3d = !render_node.nil?
    v.graphics_gl = !render_node.nil?

    # -------------
    # Input options
    # -------------
    v.input :type => "tablet", :bus => "usb"
  end

  # Runs after vagrant-libvirt defines the domain and before it starts (first boot
  # included). StartDomain keeps the rendernode attribute when it syncs the XML.
  if render_node
    config.trigger.before :"VagrantPlugins::ProviderLibvirt::Action::StartDomain", type: :action do |trigger|
      trigger.info = "Pinning SPICE GL render node to #{render_node}"
      trigger.run = { inline: "virt-xml --connect qemu:///system workstation_#{distro} --edit --graphics gl.enable=yes,gl.rendernode=#{render_node}" }
    end
  end

  if display
    config.trigger.before :up do |trigger|
      trigger.info = "Initializing graphical console"
      trigger.run = { inline: "bash -c 'virt-viewer --wait --connect qemu:///system --attach workstation_#{distro} &'" }
    end

    config.trigger.after :reload do |trigger|
      trigger.info = "Reconnecting graphical console"
      trigger.run = { inline: "bash -c 'virt-viewer --wait --connect qemu:///system --attach workstation_#{distro} &'" }
    end
  end

  # Grow root partition and filesystem to fill the resized disk
  config.vm.provision "shell", inline: <<-SHELL
    ROOT_DEV=$(df / --output=source | tail -1)
    DISK=$(lsblk -ndo PKNAME "$ROOT_DEV")
    PART_NUM=$(cat "/sys/class/block/$(basename $ROOT_DEV)/partition")
    growpart "/dev/$DISK" "$PART_NUM" || true
    if command -v btrfs &>/dev/null && btrfs filesystem show / &>/dev/null; then
      btrfs filesystem resize max /
    elif command -v xfs_growfs &>/dev/null; then
      xfs_growfs /
    else
      resize2fs "$ROOT_DEV"
    fi
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = playbook
    ansible.verbose = "#{ENV['VERBOSE']}"
    ansible.tags = tags
  end
end
