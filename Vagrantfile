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

  config.vm.define "devbox01" do |dev|
    dev.vm.box = 'vmware/dummy'
    dev.vm.box_url = './dummy.box'
    dev.vm.hostname = 'devbox01.3031.net'
    dev.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME devbox01\" >> /etc/hosts"

    dev.vm.provider :vsphere do |vsphere|
      vsphere.compute_resource_name = '3031'
      vsphere.host = ENV['VSPHERE_HOST']
      vsphere.user = ENV['VSPHERE_USER']
      vsphere.password = ENV['VSPHERE_PASSWORD']
      vsphere.insecure = true

      vsphere.memory_mb = 2048
      vsphere.cpu_count = 2

      vsphere.name = 'devbox01'
      vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
      vsphere.vm_base_path = ENV['VM_BASE_PATH']
      vsphere.template_name = 'Templates/redhat7'
    end
  end

  config.vm.define "tstbox01" do |tst|
    tst.vm.box = 'vmware/dummy'
    tst.vm.box_url = './dummy.box'
    tst.vm.hostname = 'tstbox01.3031.net'
    tst.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME tstbox01\" >> /etc/hosts"

    tst.vm.provider :vsphere do |vsphere|
      vsphere.compute_resource_name = '3031'
      vsphere.host = ENV['VSPHERE_HOST']
      vsphere.user = ENV['VSPHERE_USER']
      vsphere.password = ENV['VSPHERE_PASSWORD']
      vsphere.insecure = true

      vsphere.memory_mb = 2048
      vsphere.cpu_count = 2

      vsphere.name = 'tstbox01'
      vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
      vsphere.vm_base_path = ENV['VM_BASE_PATH']
      vsphere.template_name = 'Templates/redhat7'
    end
  end

  config.vm.define "prdbox01" do |prd|
    prd.vm.box = 'vmware/dummy'
    prd.vm.box_url = './dummy.box'
    prd.vm.hostname = 'prdbox01.3031.net'
    prd.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME prdbox01\" >> /etc/hosts"

    prd.vm.provider :vsphere do |vsphere|
      vsphere.compute_resource_name = '3031'
      vsphere.host = ENV['VSPHERE_HOST']
      vsphere.user = ENV['VSPHERE_USER']
      vsphere.password = ENV['VSPHERE_PASSWORD']
      vsphere.insecure = true

      vsphere.memory_mb = 2048
      vsphere.cpu_count = 2

      vsphere.name = 'prdbox01'
      vsphere.data_store_name = ENV['VM_DATA_STORE_NAME']
      vsphere.vm_base_path = ENV['VM_BASE_PATH']
      vsphere.template_name = 'Templates/redhat7'
    end
  end

end
