# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "puppetmaster" do |puppetmaster|
    # Set VM memory and cpu specs
    puppetmaster.vm.provider "virtualbox" do |vb|
      vb.memory = 2560
      vb.cpus = 2
    end

    # Specify box and assign a hostname
    #puppetmaster.vm.box_url = "http://vagrant.wwt.com/wwt-puppetmaster-rhel-6-7-x64-virtualbox.box"
    puppetmaster.vm.box = "wwt/2016pemaster"
    puppetmaster.vm.hostname = "puppetmaster"

    # Network Configs
    puppetmaster.vm.network "private_network", ip: "10.10.10.10"

    # Port forwarding for installer app and console app
    puppetmaster.vm.network "forwarded_port", guest: 3000, host: 3001
    puppetmaster.vm.network "forwarded_port", guest: 8140, host: 8141
    puppetmaster.vm.network "forwarded_port", guest: 443, host: 4443

    # Deploy vgt environment puppet modules
    puppetmaster.vm.provision :shell, :inline => "sudo /usr/local/bin/r10k deploy environment vgt -pv"
  end

end
