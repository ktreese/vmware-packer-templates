Vagrant.configure("2") do |config|
  config.vm.define "vmwansible" do |node|
    node.vm.box = 'vmware/dummy'
    node.vm.box_url = './dummy.box'
    node.vm.hostname = 'vmwansible'

    node.vm.provider :vsphere do |vsphere|
      vsphere.host = '192.168.1.10'
      vsphere.insecure = true
      vsphere.compute_resource_name = '3031'
      vsphere.template_name = 'Templates/redhat6'
      vsphere.name = 'vmwansible'
      vsphere.user = 'root'
      vsphere.password = ENV['SUB_PASSWORD']
      vsphere.memory_mb = 2048
      vsphere.cpu_count = 2
    end
  end
end
