# vmware-packer-templates

## Description
The vmware-packer-templates repo contains a series of long-lived branches containing packer builds / templates

These packer templates build VMware virtual machines directly on a VMware vSphere Hypervisor via the [vmware-iso](https://www.packer.io/docs/builders/vmware-iso.html) VMware Packer Builder. Once VMs are created, they may be converted into templates and deployed directly to vSphere via vagrant, using the [vagrant-vsphere](https://github.com/nsidc/vagrant-vsphere) plugin.

## Setup
In order to make use of these packer templates, you'll need to install a few things:
- [packer](https://www.packer.io/downloads.html)
- [vagrant](https://www.vagrantup.com/downloads.html)
- [vagrant-vsphere plugin](https://github.com/nsidc/vagrant-vsphere) `$ vagrant plugin install vagrant-vsphere`
 - Note: This requires [Nokogiri](http://nokogiri.org/)
- Red Hat Enterprise Linux ISOs, free via [Red Hat Developers](http://developers.redhat.com/downloads/)
- Credentials to a vSphere instance with proper access to create VMs and other administrative access
- Enable GuestIPHack (consult [vmware-iso](https://www.packer.io/docs/builders/vmware-iso.html) for detail)
 - `$ esxcli system settings advanced set -o /Net/GuestIPHack -i 1` 
- A dummy vagrant vSphere box.  Create a file named `metadata.json` with the following content:
```json
{
  "provider": "vsphere"
}
```
- Create the box
 - `$ tar cvzf dummy.box ./metadata.json`
- Add the box
 - `$ vagrant box add --name vmware/dummy dummy.box`
- Vagrantfile
```ruby
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
      vsphere.name = 'vmwpuppetmaster'
      vsphere.vm_base_path = 'vagrant_deployments'
      vsphere.user = 'root'
      vsphere.password = ENV['SUB_PASSWORD']
      vsphere.memory_mb = 4096
      vsphere.cpu_count = 2
    end
  end
end
```
\* When using vagrant commands, you'll be prompted for your vSphere password per the `ENV['SUB_PASSWORD']` value.  Alternatively, this may be set as an environment variable and exported to avoid entering it multiple times:
```bash
$ SUB_PASSWORD=vSphere_Password
$ export SUB_PASSWORD
```

## Branch Descriptions
Each branch represents the OS or application it is named after.  Refer to the usage examples to conduct a build via packer.

- `master:` Contains just the README for now.  Each branch is intended to be long lived for the build it represents

- `redhat6:` Builds a Red Hat 6 virtual machine based off a 6.8 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the Red Hat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.

- `redhat7:` Builds a Red Hat 7 virtual machine based off a 7.2 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the Red Hat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.

- `pe.2016.2.1:` Using the same virtual machine packer build as `redhat6`, this deployment includes an additional puppet shell provisioner to install a base installation/setup of Puppet Enterprise 2016.2.1.

## User Variables
There are some packer user variables that will need to be passed in:

- `submgr_password` Subscription Manager password of your Red Hat Developer account
- `vmware_password` vSphere instance password

This can be done in one of two ways:

- ###### From The Command Line
Use the `-var` flag:
 - `$ packer build -var 'submgr_pass=foo' -var 'vmware_password=bar' puppetmaster.json`

- ###### From A File
Variables can also be set from an external JSON file.  Use the `-var-file` flag:
```json
{
  "submgr_password": "foo",
  "vmware_password": "bar"
}
```

Assuming a file name of `variables.json`:
- `$ packer build -var-file=variables.json puppetmaster.json`

Note: I've hard coded a lot of stuff in the packer templates, such as the `remote_host`, `remote_username`, `remote_datastore`, etc.  I've also hard set things in the kickstart config such as my username.  Eventually, I plan to parameterize as much as I can to make this as reusable as possible for others, but is what it is for now.  Best case is to fork and adjust values to your environment.


##### Usage Examples:
```bash
$ packer validate rhel-server-7-x86_64.json      validate template syntax
$ packer build rhel-server-7-x86_64.json         build a RedHat 7 vagrant box
```

###### Watching The Build
Packer requires VNC to issue boot commands during a build.  When the VM build is run headless, without a GUI, you can view the screen of the VM by connecting via VNC with the password and IP:port provided in the build output.

The best way to do this on a Mac is to open Safari, and type in `vnc://ipaddress`.  Screen Sharing will open up.  Pin the icon to your dock for future use.  Screen Sharing works beautifully to connect to a VNC server, and it's built right in to MacOS!

## Making it useful for VMware
Once the packer build completes, login to your vSphere instance and convert the machine into a vmware template.  Move it to the `Templates` folder, and using the Vagrantfile example above:
```
$ vagrant up vmwpuppetmaster
$ vagrant ssh vmwpuppetmaster
```

## Example Run
