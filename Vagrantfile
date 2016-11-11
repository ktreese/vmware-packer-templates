# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "subscribed1" do |redhat|
    redhat.vm.box = "wwt/rhel-subscribed"
    redhat.vm.hostname = "redhat01"

    # Network Configs
    redhat.vm.network "private_network", ip: "10.10.10.100"
  end
  config.vm.define "subscribed2" do |redhat|
    redhat.vm.box = "wwt/rhel-subscribed"
    redhat.vm.hostname = "redhat02"

    # Network Configs
    redhat.vm.network "private_network", ip: "10.10.10.101"
  end
end
