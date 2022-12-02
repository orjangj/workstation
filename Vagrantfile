# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

distro = ENV['DISTRO'] || "ubuntu"
playbook = ENV['PLAYBOOK'] || "converge.yml"
tags = ENV['TAGS'] || "never"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false

  case distro
  when "arch"
    config.vm.hostname = "arch"
    config.vm.network :private_network, ip: "192.168.56.21"
    config.vm.define :arch do |arch|
      config.vm.box = "archlinux/archlinux"
    end
  when "fedora"
    config.vm.hostname = "fedora"
    config.vm.network :private_network, ip: "192.168.56.22"
    config.vm.define :fedora do |fedora|
      config.vm.box = "generic/fedora37"
    end
  when "ubuntu"
    config.vm.hostname = "ubuntu"
    config.vm.network :private_network, ip: "192.168.56.23"
    config.vm.define :ubuntu do |ubuntu|
      config.vm.box = "ubuntu/jammy64"
    end
  else
    config.vm.hostname = "ubuntu"
    config.vm.network :private_network, ip: "192.168.56.23"
    config.vm.define :ubuntu do |ubuntu|
      config.vm.box = "ubuntu/jammy64"
    end
  end

  config.vm.provider :virtualbox do |v|
    v.name = config.vm.hostname
    v.memory = 8192
    v.cpus = 4
    v.gui = true
    # Accept DNS traffic from the guest, but use host's OS API's to resolve the query
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # Required when using more than one virtual CPU
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    # Nice to have
    v.customize ['modifyvm', :id, "--clipboard", "bidirectional"]
    v.customize ['modifyvm', :id, "--mouse", "usbtablet"]
  end
  
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = playbook
    ansible.verbose = "#{ENV['VERBOSE']}"
    ansible.inventory_path = "vagrant/inventory"
    ansible.tags = tags
  end
end
