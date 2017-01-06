Vagrant.configure("2") do |config|

  config.vm.define "vmwpuppetmaster" do |vmwpuppetmaster|
    vmwpuppetmaster.vm.box = 'vmware/dummy'
    vmwpuppetmaster.vm.box_url = './dummy.box'
    vmwpuppetmaster.vm.hostname = 'vmwpuppetmaster.3031.net'
    vmwpuppetmaster.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME vmwpuppetmaster\" >> /etc/hosts"

    vmwpuppetmaster.vm.provider :vsphere do |vsphere|
      vsphere.compute_resource_name = '3031'
      vsphere.host = ENV['VSPHERE_HOST']
      vsphere.user = ENV['VSPHERE_USER']
      vsphere.password = ENV['VSPHERE_PASSWORD']
      vsphere.insecure = true

      vsphere.memory_mb = 4096
      vsphere.cpu_count = 2

      vsphere.name = 'vmwpuppetmaster'
      vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
      vsphere.vm_base_path = ENV['VM_BASE_PATH']
      vsphere.template_name = 'Templates/puppetmaster'
    end
  end

  config.vm.define "vmwdnsmasq" do |vmwdnsmasq|
    vmwdnsmasq.vm.box = 'vmware/dummy'
    vmwdnsmasq.vm.box_url = './dummy.box'
    vmwdnsmasq.vm.hostname = 'vmwdnsmasq.3031.net'
    vmwdnsmasq.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME vmwdnsmasq\" >> /etc/hosts"

    vmwdnsmasq.vm.provider :vsphere do |vsphere|
      vsphere.compute_resource_name = '3031'
      vsphere.host = ENV['VSPHERE_HOST']
      vsphere.user = ENV['VSPHERE_USER']
      vsphere.password = ENV['VSPHERE_PASSWORD']
      vsphere.insecure = true

      vsphere.memory_mb = 2048
      vsphere.cpu_count = 2

      vsphere.name = 'vmwdnsmasq'
      vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
      vsphere.vm_base_path = ENV['VM_BASE_PATH']
      vsphere.template_name = 'Templates/redhat7'
    end
  end

  config.vm.define "vmwdnsmasq01" do |vmwdns|
    vmwdns.vm.box = 'vmware/dummy'
    vmwdns.vm.box_url = './dummy.box'
    vmwdns.vm.hostname = 'vmwdnsmasq01.3031.net'
    vmwdns.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME vmwdnsmasq01\" >> /etc/hosts"

    vmwdns.vm.provider :vsphere do |vsphere|
      vsphere.compute_resource_name = '3031'
      vsphere.host = ENV['VSPHERE_HOST']
      vsphere.user = ENV['VSPHERE_USER']
      vsphere.password = ENV['VSPHERE_PASSWORD']
      vsphere.insecure = true

      vsphere.memory_mb = 2048
      vsphere.cpu_count = 2

      vsphere.name = 'vmwdnsmasq01'
      vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
      vsphere.vm_base_path = ENV['VM_BASE_PATH']
      vsphere.template_name = 'Templates/redhat7'
    end
  end

end
