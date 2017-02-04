# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')
domain = '.3031.net'

Vagrant.configure("2") do |config|
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.box_url = servers["box_url"]
      srv.vm.hostname = servers["name"] << domain
      srv.vm.hostname = servers["name"]
      srv.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME " + servers["name"].split(".").first + "\" >> /etc/hosts"

      srv.vm.provider :vsphere do |vsphere|
        vsphere.compute_resource_name = '3031'
        vsphere.host = ENV['VSPHERE_HOST']
        vsphere.user = ENV['VSPHERE_USER']
        vsphere.password = ENV['VSPHERE_PASSWORD']
        vsphere.insecure = true

        vsphere.memory_mb = servers["memory_mb"]
        vsphere.cpu_count = servers["cpu_count"]

        vsphere.name = servers["name"].split(".").first
        vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
        vsphere.vm_base_path = ENV['VM_BASE_PATH']
        vsphere.template_name = 'Templates/' + servers["template"]
      end
    end
  end
end
