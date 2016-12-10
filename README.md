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

Otherwise, edit export.sh and source it before running any vagrant up commands

## Branch Descriptions
Each branch represents the OS or application it is named after.  Refer to the usage examples to conduct a build via packer.

- `master:` Contains the Vagrantfile used to manage deployments of VMs to vCenter. This allows vagrant to serve as the provisioner of lab systems, using the templates created by the other topic branches of this repository.

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
```
➜  vmware-packer-templates git:(redhat7) ✗ packer build -var 'submgr_pass=password' -var 'vmware_password=password' rhel-server-7-x86_64.json 
vmware-iso output will be in this color.

Warnings for build 'vmware-iso':

* A checksum type of 'none' was specified. Since ISO files are so big,
a checksum is highly recommended.

==> vmware-iso: Downloading or copying ISO
    vmware-iso: Downloading or copying: file:///Users/reesek/Downloads/redhat/rhel-server-7.2-x86_64-dvd.iso
==> vmware-iso: Uploading ISO to remote machine...
==> vmware-iso: Creating virtual machine disk
==> vmware-iso: Building and writing VMX file
==> vmware-iso: Starting HTTP server on port 8933
==> vmware-iso: Registering remote VM...
==> vmware-iso: Starting virtual machine...
    vmware-iso: The VM will be run headless, without a GUI. If you want to
    vmware-iso: view the screen of the VM, connect via VNC with the password "@uHR4?(:" to
    vmware-iso: 192.168.1.2:5988
==> vmware-iso: Waiting 10s for boot...
==> vmware-iso: Connecting to VM via VNC
==> vmware-iso: Typing the boot command over VNC...
==> vmware-iso: Waiting for SSH to become available...
==> vmware-iso: Connected to SSH!
==> vmware-iso: Provisioning with shell script: scripts/base.sh
==> vmware-iso: Provisioning with shell script: scripts/vagrant.sh
    vmware-iso: % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    vmware-iso: Dload  Upload   Total   Spent    Left  Speed
    vmware-iso: 100   409  100   409    0     0   2175      0 --:--:-- --:--:-- --:--:--  2187
==> vmware-iso: Provisioning with shell script: scripts/redhat-vmware-tools_install.sh
    vmware-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    vmware-iso: Resolving Dependencies
    vmware-iso: --> Running transaction check
    vmware-iso: ---> Package open-vm-tools.x86_64 0:10.0.5-2.el7 will be installed
    vmware-iso: --> Processing Dependency: fuse for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libfuse.so.2(FUSE_2.5)(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libfuse.so.2(FUSE_2.6)(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libdnet.so.1()(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libfuse.so.2()(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libicudata.so.50()(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libicui18n.so.50()(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libicuuc.so.50()(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Processing Dependency: libmspack.so.0()(64bit) for package: open-vm-tools-10.0.5-2.el7.x86_64
    vmware-iso: --> Running transaction check
    vmware-iso: ---> Package fuse.x86_64 0:2.9.2-7.el7 will be installed
    vmware-iso: ---> Package fuse-libs.x86_64 0:2.9.2-7.el7 will be installed
    vmware-iso: ---> Package libdnet.x86_64 0:1.12-13.1.el7 will be installed
    vmware-iso: ---> Package libicu.x86_64 0:50.1.2-15.el7 will be installed
    vmware-iso: ---> Package libmspack.x86_64 0:0.5-0.4.alpha.el7 will be installed
    vmware-iso: --> Finished Dependency Resolution
    vmware-iso:
    vmware-iso: Dependencies Resolved
    vmware-iso:
    vmware-iso: ================================================================================
    vmware-iso: Package          Arch      Version                 Repository             Size
    vmware-iso: ================================================================================
    vmware-iso: Installing:
    vmware-iso: open-vm-tools    x86_64    10.0.5-2.el7            rhel-7-server-rpms    513 k
    vmware-iso: Installing for dependencies:
    vmware-iso: fuse             x86_64    2.9.2-7.el7             rhel-7-server-rpms     85 k
    vmware-iso: fuse-libs        x86_64    2.9.2-7.el7             rhel-7-server-rpms     93 k
    vmware-iso: libdnet          x86_64    1.12-13.1.el7           rhel-7-server-rpms     31 k
    vmware-iso: libicu           x86_64    50.1.2-15.el7           rhel-7-server-rpms    6.9 M
    vmware-iso: libmspack        x86_64    0.5-0.4.alpha.el7       rhel-7-server-rpms     64 k
    vmware-iso:
    vmware-iso: Transaction Summary
    vmware-iso: ================================================================================
    vmware-iso: Install  1 Package (+5 Dependent packages)
    vmware-iso:
    vmware-iso: Total download size: 7.6 M
    vmware-iso: Installed size: 26 M
    vmware-iso: Downloading packages:
    vmware-iso: --------------------------------------------------------------------------------
    vmware-iso: Total                                              2.8 MB/s | 7.6 MB  00:02
    vmware-iso: Running transaction check
    vmware-iso: Running transaction test
    vmware-iso: Transaction test succeeded
    vmware-iso: Running transaction
    vmware-iso: Installing : libmspack-0.5-0.4.alpha.el7.x86_64                           1/6
    vmware-iso: Installing : libdnet-1.12-13.1.el7.x86_64                                 2/6
    vmware-iso: Installing : libicu-50.1.2-15.el7.x86_64                                  3/6
    vmware-iso: Installing : fuse-libs-2.9.2-7.el7.x86_64                                 4/6
    vmware-iso: Installing : fuse-2.9.2-7.el7.x86_64                                      5/6
    vmware-iso: Installing : open-vm-tools-10.0.5-2.el7.x86_64                            6/6
    vmware-iso: Verifying  : open-vm-tools-10.0.5-2.el7.x86_64                            1/6
    vmware-iso: Verifying  : fuse-2.9.2-7.el7.x86_64                                      2/6
    vmware-iso: Verifying  : fuse-libs-2.9.2-7.el7.x86_64                                 3/6
    vmware-iso: Verifying  : libicu-50.1.2-15.el7.x86_64                                  4/6
    vmware-iso: Verifying  : libdnet-1.12-13.1.el7.x86_64                                 5/6
    vmware-iso: Verifying  : libmspack-0.5-0.4.alpha.el7.x86_64                           6/6
    vmware-iso:
    vmware-iso: Installed:
    vmware-iso: open-vm-tools.x86_64 0:10.0.5-2.el7
    vmware-iso:
    vmware-iso: Dependency Installed:
    vmware-iso: fuse.x86_64 0:2.9.2-7.el7                 fuse-libs.x86_64 0:2.9.2-7.el7
    vmware-iso: libdnet.x86_64 0:1.12-13.1.el7            libicu.x86_64 0:50.1.2-15.el7
    vmware-iso: libmspack.x86_64 0:0.5-0.4.alpha.el7
    vmware-iso:
    vmware-iso: Complete!
==> vmware-iso: Provisioning with shell script: scripts/redhat-vmware-cleanup.sh
    vmware-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    vmware-iso: Resolving Dependencies
    vmware-iso: --> Running transaction check
    vmware-iso: ---> Package kernel.x86_64 0:3.10.0-327.el7 will be erased
    vmware-iso: --> Finished Dependency Resolution
    vmware-iso:
    vmware-iso: Dependencies Resolved
    vmware-iso:
    vmware-iso: ================================================================================
    vmware-iso: Package       Arch          Version                 Repository            Size
    vmware-iso: ================================================================================
    vmware-iso: Removing:
    vmware-iso: kernel        x86_64        3.10.0-327.el7          @anaconda/7.2        136 M
    vmware-iso:
    vmware-iso: Transaction Summary
    vmware-iso: ================================================================================
    vmware-iso: Remove  1 Package
    vmware-iso:
    vmware-iso: Installed size: 136 M
    vmware-iso: Downloading packages:
    vmware-iso: Running transaction check
    vmware-iso: Running transaction test
    vmware-iso: Transaction test succeeded
    vmware-iso: Running transaction
    vmware-iso: Erasing    : kernel-3.10.0-327.el7.x86_64                                 1/1
    vmware-iso: Verifying  : kernel-3.10.0-327.el7.x86_64                                 1/1
    vmware-iso:
    vmware-iso: Removed:
    vmware-iso: kernel.x86_64 0:3.10.0-327.el7
    vmware-iso:
    vmware-iso: Complete!
    vmware-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    vmware-iso: Resolving Dependencies
    vmware-iso: --> Running transaction check
    vmware-iso: ---> Package kernel-devel.x86_64 0:3.10.0-327.el7 will be erased
    vmware-iso: --> Finished Dependency Resolution
    vmware-iso:
    vmware-iso: Dependencies Resolved
    vmware-iso:
    vmware-iso: ================================================================================
    vmware-iso: Package            Arch         Version              Repository           Size
    vmware-iso: ================================================================================
    vmware-iso: Removing:
    vmware-iso: kernel-devel       x86_64       3.10.0-327.el7       @anaconda/7.2        33 M
    vmware-iso:
    vmware-iso: Transaction Summary
    vmware-iso: ================================================================================
    vmware-iso: Remove  1 Package
    vmware-iso:
    vmware-iso: Installed size: 33 M
    vmware-iso: Downloading packages:
    vmware-iso: Running transaction check
    vmware-iso: Running transaction test
    vmware-iso: Transaction test succeeded
    vmware-iso: Running transaction
    vmware-iso: Erasing    : kernel-devel-3.10.0-327.el7.x86_64                           1/1
    vmware-iso: Verifying  : kernel-devel-3.10.0-327.el7.x86_64                           1/1
    vmware-iso:
    vmware-iso: Removed:
    vmware-iso: kernel-devel.x86_64 0:3.10.0-327.el7
    vmware-iso:
    vmware-iso: Complete!
    vmware-iso: ==> Pausing for 0 seconds...
    vmware-iso: ==> Cleaning up yum cache
    vmware-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    vmware-iso: Cleaning repos: rhel-7-server-optional-rpms rhel-7-server-rpms
    vmware-iso: : rhel-ha-for-rhel-7-server-rpms rhel-rs-for-rhel-7-server-rpms
    vmware-iso: : rhel-server-rhscl-7-rpms
    vmware-iso: Cleaning up everything
    vmware-iso: ==> Force logs to rotate
    vmware-iso: ==> Clear audit log and wtmp
    vmware-iso: ==> Remove the traces of the template MAC address and UUIDs
    vmware-iso: ==> Cleaning up tmp
    vmware-iso: ==> Remove the SSH host keys
    vmware-iso: ==> Remove the root user’s shell history
    vmware-iso: ==> yum -y clean all
    vmware-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    vmware-iso: Cleaning repos: rhel-7-server-optional-rpms rhel-7-server-rpms
    vmware-iso: : rhel-ha-for-rhel-7-server-rpms rhel-rs-for-rhel-7-server-rpms
    vmware-iso: : rhel-server-rhscl-7-rpms
    vmware-iso: Cleaning up everything
    vmware-iso: ==> Zero out the free space to save space in the final image
    vmware-iso: dd: error writing ‘/EMPTY’: No space left on device
    vmware-iso: 17564+0 records in
    vmware-iso: 17563+0 records out
    vmware-iso: 18416300032 bytes (18 GB) copied, 1740.87 s, 10.6 MB/s
==> vmware-iso: Gracefully halting virtual machine...
    vmware-iso: Waiting for VMware to clean up after itself...
==> vmware-iso: Deleting unnecessary VMware files...
    vmware-iso: Deleting: /vmfs/volumes/vmstore02_lun/redhat7_template/vmware.log
==> vmware-iso: Compacting the disk image
==> vmware-iso: Cleaning VMX prior to finishing up...
    vmware-iso: Unmounting floppy from VMX...
    vmware-iso: Detaching ISO from CD-ROM device...
    vmware-iso: Disabling VNC server...
==> vmware-iso: Keeping virtual machine registered with ESX host (keep_registered = true)
Build 'vmware-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso: VM files in directory: /vmfs/volumes/vmstore02_lun/redhat7_template
```
