# packer-templates

Builds a vagrant box for the virtualbox provider for specified os type:

##### Branch Descriptions
Each branch represents the OS it is named after.  Following the quick and dirty example usage below will build a vagrant box for the os the branch represents.  Otherwise, here are some specifics as they pertain to certain branches:

- `master:` Contains just the README for now.  Each branch is intended to be long lived for the OS build is represents

- `developer:` Builds a Red Hat 6 virtualbox image based off a 6.7 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the redhat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.  Once tested extensively, it will be merged into the `redhat6` branch

- `pe.2016.2.1.entitlement:` First build of a puppet master using an entitlement.  This completely removes the dependency on using CentOS repos for package installs.  Use of Red Hat Customer Portal is being tested before this gets merged into `pe.2016.2.1` and published for public consumption within the wwt-pe-master-vagrant project

- `pe.2016.2.1_raw:` A base installation/setup of Puppet Enterprise 2016.2.1 without any custom WWT configs built in.  If developer builds above pan out, this will need a little refactoring to also register directly with Red Hat Customer Portal

##### Quick and dirty example usage:
```
$ packer validate rhel-server-7-x86_64.json      validate template syntax
$ packer build rhel-server-7-x86_64.json         build a RedHat 7 vagrant box
$ add.sh                                         add vagrant box
$ vagrant up                                     boot based of distributed Vagrantfile
$ vagrant ssh                                    ssh into the vagrant machine
```

# Example Run
```
➜  packer-templates git:(master) packer build rhel-server-7-x86_64.json
virtualbox-iso output will be in this color.

==> virtualbox-iso: Downloading or copying Guest additions
    virtualbox-iso: Downloading or copying: file:///Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
==> virtualbox-iso: Downloading or copying ISO
    virtualbox-iso: Downloading or copying: file:///Users/reesek/Downloads/redhat/rhel-server-7.2-x86_64-dvd.iso
==> virtualbox-iso: Starting HTTP server on port 8770
==> virtualbox-iso: Creating virtual machine...
==> virtualbox-iso: Creating hard drive...
==> virtualbox-iso: Creating forwarded port mapping for SSH (host port 2762)
==> virtualbox-iso: Executing custom VBoxManage commands...
    virtualbox-iso: Executing: modifyvm packer-virtualbox-iso-1469070098 --memory 2048
    virtualbox-iso: Executing: modifyvm packer-virtualbox-iso-1469070098 --cpus 2
==> virtualbox-iso: Starting the virtual machine...
    virtualbox-iso: WARNING: The VM will be started in headless mode, as configured.
    virtualbox-iso: In headless mode, errors during the boot sequence or OS setup
    virtualbox-iso: won't be easily visible. Use at your own discretion.
==> virtualbox-iso: Waiting 10s for boot...
==> virtualbox-iso: Typing the boot command...
==> virtualbox-iso: Waiting for SSH to become available...
==> virtualbox-iso: Connected to SSH!
==> virtualbox-iso: Uploading VirtualBox version info (5.0.20)
==> virtualbox-iso: Uploading VirtualBox guest additions ISO...
==> virtualbox-iso: Provisioning with shell script: scripts/base.sh
    virtualbox-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    virtualbox-iso: There are no enabled repos.
    virtualbox-iso: This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    virtualbox-iso: Run "yum repolist all" to see the repos you have.
    virtualbox-iso: You can enable repos with yum-config-manager --enable <repo>
==> virtualbox-iso: Provisioning with shell script: scripts/vagrant.sh
    virtualbox-iso: % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    virtualbox-iso: Dload  Upload   Total   Spent    Left  Speed
    virtualbox-iso: 100   409  100   409    0     0    658      0 --:--:-- --:--:-- --:--:--   657
==> virtualbox-iso: Provisioning with shell script: scripts/virtualbox.sh
    virtualbox-iso: mount: /dev/loop0 is write-protected, mounting read-only
    virtualbox-iso: Verifying archive integrity... All good.
    virtualbox-iso: Uncompressing VirtualBox 5.0.20 Guest Additions for Linux............
    virtualbox-iso: VirtualBox Guest Additions installer
    virtualbox-iso: Copying additional installer modules ...
    virtualbox-iso: Installing additional modules ...
    virtualbox-iso: Removing existing VirtualBox non-DKMS kernel modules[  OK  ]
    virtualbox-iso: Building the VirtualBox Guest Additions kernel modules
    virtualbox-iso: Building the main Guest Additions module[  OK  ]
    virtualbox-iso: Building the shared folder support module[  OK  ]
    virtualbox-iso: Building the graphics driver module[  OK  ]
    virtualbox-iso: Doing non-kernel setup of the Guest Additions[  OK  ]
    virtualbox-iso: Starting the VirtualBox Guest Additions Installing the Window System drivers
    virtualbox-iso: Could not find the X.Org or XFree86 Window System, skipping.
    virtualbox-iso: [  OK  ]
==> virtualbox-iso: Provisioning with shell script: scripts/cleanup.sh
    virtualbox-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    virtualbox-iso: This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    virtualbox-iso: No Match for argument: kernel-2.6.32-431.el6.x86_64
    virtualbox-iso: No Packages marked for removal
    virtualbox-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    virtualbox-iso: This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    virtualbox-iso: There are no enabled repos.
    virtualbox-iso: Run "yum repolist all" to see the repos you have.
    virtualbox-iso: You can enable repos with yum-config-manager --enable <repo>
==> virtualbox-iso: Provisioning with shell script: scripts/zerodisk.sh
    virtualbox-iso: dd: error writing ‘/EMPTY’: No space left on device
    virtualbox-iso: 36652+0 records in
    virtualbox-iso: 36651+0 records out
    virtualbox-iso: 38432313344 bytes (38 GB) copied, 153.898 s, 250 MB/s
==> virtualbox-iso: Gracefully halting virtual machine...
==> virtualbox-iso: Preparing to export machine...
    virtualbox-iso: Deleting forwarded port mapping for SSH (host port 2762)
==> virtualbox-iso: Exporting virtual machine...
    virtualbox-iso: Executing: export packer-virtualbox-iso-1469070098 --output output-virtualbox-iso/packer-virtualbox-iso-1469070098.ovf
==> virtualbox-iso: Unregistering and deleting virtual machine...
==> virtualbox-iso: Running post-processor: vagrant
==> virtualbox-iso (vagrant): Creating Vagrant box for 'virtualbox' provider
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso/packer-virtualbox-iso-1469070098-disk1.vmdk
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso/packer-virtualbox-iso-1469070098.ovf
    virtualbox-iso (vagrant): Renaming the OVF to box.ovf...
    virtualbox-iso (vagrant): Compressing: Vagrantfile
    virtualbox-iso (vagrant): Compressing: box.ovf
    virtualbox-iso (vagrant): Compressing: metadata.json
    virtualbox-iso (vagrant): Compressing: packer-virtualbox-iso-1469070098-disk1.vmdk
Build 'virtualbox-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-iso: 'virtualbox' provider box: redhat-7-x64-virtualbox.box
➜  packer-templates git:(master)
```
