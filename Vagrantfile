# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

distro = ENV['VM_DISTRO'] || "fedora"
playbook = ENV['PLAYBOOK'] || "converge.yml"
tags = ENV['TAGS'] || "never"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  case distro
  when "archlinux"
    config.vm.hostname = "arch"
    #config.vm.network :private_network, ip: "192.168.56.21"
    config.vm.define :arch do |arch|
      config.vm.box = "archlinux/archlinux"
    end

    # Ensure python3 is installed before running ansible provisioner
    config.vm.provision "shell", inline: "pacman -Syy --needed --noconfirm python3"
  when "debian"
    config.vm.hostname = "debian"
    #config.vm.network :private_network, ip: "192.168.56.23"
    config.vm.define :debian do |debian|
      config.vm.box = "debian/bookworm64"
    end
  when "fedora"
    config.vm.hostname = "fedora"
    #config.vm.network :private_network, ip: "192.168.56.22"
    # NOTE: fedora36+ has a change in how networks are configured
    # Vagrant doesn't seem to support that yet, and as a consequence vagrant
    # is unable to set a static IP... See https://github.com/hashicorp/vagrant/issues/12762
    config.vm.define :fedora do |fedora|
      config.vm.box = "fedora/38-cloud-base"
    end
  end

  # REF: https://vagrant-libvirt.github.io/vagrant-libvirt/configuration.html
  config.vm.provider :libvirt do |v|
    # See https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html#qemu-session-support
    #v.qemu_use_session = true  # If set, v.uri is qemu:///session, else uri is qemu:///system
    v.memory = 8192
    v.cpus = 4
    v.graphics_type = "spice"
    v.video_type = "virtio"
    v.video_accel3d = true  # Consider setting v.kvm_hidden if misbehaving

    # -------------
    # Input options
    # -------------
    v.input :type => "tablet", :bus => "usb"
  end

  config.trigger.before :up do |trigger|
    trigger.info = "Initializing graphical console"
    # NOTE: Libvirt creates VM with name corresponding to current working directory + _ + distro name.
    trigger.run = { inline: "bash -c 'virt-viewer --wait --connect qemu:///system --attach workstation_#{distro} &'" }
  end

  config.trigger.after :reload do |trigger|
    trigger.info = "Reconnecting graphical console"
    # NOTE: Libvirt creates VM with name corresponding to current working directory + _ + distro name.
    trigger.run = { inline: "bash -c 'virt-viewer --wait --connect qemu:///system --attach workstation_#{distro} &'" }
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = playbook
    ansible.verbose = "#{ENV['VERBOSE']}"
    #ansible.inventory_path = "vagrant/inventory"
    ansible.tags = tags
  end
end
