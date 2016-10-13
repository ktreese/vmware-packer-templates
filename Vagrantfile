# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "redhat67" do |redhat|
    redhat.vm.box = "wwt/rhel-server-6.7-x86_64"
    redhat.vm.hostname = "redhat"

    # Network Configs
    redhat.vm.network "private_network", ip: "10.10.10.100"
  end
end
