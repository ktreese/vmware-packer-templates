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

  # Puppet Agent(s) config namespace 'config.vm' below this line
  config.vm.define "vgtrazor" do |node|
    # Set VM memory and cpu specs
    node.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end

    node.vm.box = "wwt/rhel-server-6.7-x86_64"
    node.vm.box_url = "http://vagrant.wwt.com/wwt-rhel-6-7-x64-virtualbox.box"
    node.vm.box_download_insecure = true
    node.ssh.pty = true
    node.vm.hostname = "vgtrazor.wwt.local"
    node.vm.network "private_network", ip: "10.10.10.100"

    # Port forwarding for installer app and console app
    node.vm.network "forwarded_port", guest: 8150, host: 8150
    node.vm.network "forwarded_port", guest: 8151, host: 8151

    # Install Puppet Agent
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.10  puppetmaster.wwt.local' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.100 vgtrazor vgtrazor.wwt.local vgtrazor.wwt.com' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo curl -k https://puppetmaster.wwt.local:8140/packages/current/install.bash | sudo bash"

    # Razor pre-reqs (for development environments only; do not replicate to production)
    node.vm.provision :shell, :inline => "sudo yum install -y dnsmasq wget"
    node.vm.provision :shell, :inline => "sudo mkdir -p /var/lib/tftpboot; sudo chmod 655 /var/lib/tftpboot"
    node.vm.provision :shell, :inline => "sudo echo 'bind-interfaces' >> /etc/dnsmasq.conf"
    node.vm.provision :shell, :inline => "sudo echo 'interface=eth1' >> /etc/dnsmasq.conf"
    node.vm.provision :shell, :inline => "sudo echo 'dhcp-range=eth1,10.10.10.200,10.10.10.240,24h' >> /etc/dnsmasq.conf"
    node.vm.provision :shell, :inline => "sudo sed -i -e 's:#conf-dir:conf-dir:g' /etc/dnsmasq.conf"
    node.vm.provision :shell, :inline => "sudo cp /vagrant/files/razor /etc/dnsmasq.d/"
    node.vm.provision :shell, :inline => "sudo cp /vagrant/files/.bashrc /root/"
    node.vm.provision :shell, :inline => "sudo chkconfig dnsmasq on"
    node.vm.provision :shell, :inline => "sudo service dnsmasq start"
    node.vm.provision :shell, :inline => "sudo wget https://s3.amazonaws.com/pe-razor-resources/undionly-20140116.kpxe -O /var/lib/tftpboot/undionly-20140116.kpxe"
  end

end
