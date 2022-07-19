# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

playbook = ENV['PLAYBOOK'] || "local.yml"
tags = ENV['TAGS'] || "never"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "archlinux/archlinux"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.name = "arch"
    v.memory = 8192
    v.cpus = 4
    v.gui = true
    # Accept DNS traffic from the guest, but use host's OS API's to resolve the query
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # Required when using more than one virtual CPU
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.hostname = "arch"
  config.vm.network :private_network, ip: "192.168.56.21"

  # Set the name of the VM. See: http://stackoverflow.com/a/17864388/100134
  config.vm.define :arch do |arch|
  end

  #config.vm.provision "shell", inline: "loadkeys no"
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = playbook
    ansible.verbose = "#{ENV['VERBOSE']}"
    ansible.inventory_path = "vagrant/inventory"
    ansible.tags = tags
  end
end
