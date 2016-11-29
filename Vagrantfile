Vagrant.configure("2") do |config|
  config.vm.define "puppetmaster" do |puppetmaster|
    puppetmaster.vm.box = 'vmware/dummy'
    puppetmaster.vm.box_url = './dummy.box'
    puppetmaster.vm.hostname = 'vmwpuppetmaster'
    puppetmaster.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME\" >> /etc/hosts"

    puppetmaster.vm.provider :vsphere do |vsphere|
      vsphere.host = '192.168.1.10'
      vsphere.insecure = true
      vsphere.compute_resource_name = '3031'
      vsphere.template_name = 'Templates/puppetmaster'
      vsphere.name = 'vmwpuppetmaster'
      vsphere.user = 'root'
      vsphere.password = ENV['SUB_PASSWORD']
      vsphere.memory_mb = 4096
      vsphere.cpu_count = 2
    end
  end
end
