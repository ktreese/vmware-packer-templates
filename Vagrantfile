Vagrant.configure("2") do |config|
  config.vm.define "vmwpuppetmaster" do |vmwpuppetmaster|
    vmwpuppetmaster.vm.box = 'vmware/dummy'
    vmwpuppetmaster.vm.box_url = './dummy.box'
    vmwpuppetmaster.vm.hostname = 'vmwpuppetmaster.3031.net'
    vmwpuppetmaster.vm.provision :shell, :inline => "sudo /bin/echo \"$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME vmwpuppetmaster\" >> /etc/hosts"

    vmwpuppetmaster.vm.provider :vsphere do |vsphere|
      vsphere.host = '192.168.1.10'
      vsphere.insecure = true
      vsphere.compute_resource_name = '3031'
      vsphere.template_name = 'Templates/puppetmaster'
      vsphere.vm_base_path = 'vagrant_deployments'
      vsphere.name = 'vmwpuppetmaster'
      vsphere.vm_base_path = 'vagrant_deployments'
      vsphere.user = 'root'
      vsphere.password = ENV['SUB_PASSWORD']
      vsphere.memory_mb = 4096
      vsphere.cpu_count = 2
    end
  end
end
