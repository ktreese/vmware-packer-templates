# packer-templates

Builds a vagrant box for the virtualbox provider for specified os type:

##### Branch Descriptions
Each branch represents the OS it is named after.  Following the quick and dirty example usage below will build a vagrant box for the os the branch represents.  Otherwise, here are some specifics as they pertain to certain branches:

- `master:` Contains just the README for now.  Each branch is intended to be long lived for the OS build is represents

- `rhel6:` Builds a Red Hat 6 virtualbox image based off a 6.8 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the redhat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.

- `rhel7:` Builds a Red Hat 7 virtualbox image based off a 7.2 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the redhat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.

- `pe.2016.2.1:` First build of a puppet master using an entitlement.  This completely removes the dependency on using CentOS repos for package installs.  Use of Red Hat Customer Portal has been tested and published for public consumption within the wwt-pe-master-vagrant project

- `pe.2016.2.1_raw:` A base installation/setup of Puppet Enterprise 2016.2.1 without any custom WWT configs built in.  This is more of a staged build to test new implementations of puppet configurations in a vanilla environment

- `vmware:` In development; using the vmware-iso builder to build machines directly on an ESXi host

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
➜  packer-templates git:(rh7_developer) ✗ packer build -var 'submgr_pass=RedHatCustomerPortalPassword' rhel-server-7-x86_64.json
virtualbox-iso output will be in this color.

==> virtualbox-iso: Downloading or copying Guest additions
    virtualbox-iso: Downloading or copying: file:///Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
==> virtualbox-iso: Downloading or copying ISO
    virtualbox-iso: Downloading or copying: file:///Users/reesek/Downloads/redhat/rhel-server-7.2-x86_64-dvd.iso
==> virtualbox-iso: Starting HTTP server on port 8873
==> virtualbox-iso: Creating virtual machine...
==> virtualbox-iso: Creating hard drive...
==> virtualbox-iso: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3936)
==> virtualbox-iso: Executing custom VBoxManage commands...
    virtualbox-iso: Executing: modifyvm packer-virtualbox-iso-1479327412 --memory 512
    virtualbox-iso: Executing: modifyvm packer-virtualbox-iso-1479327412 --cpus 2
==> virtualbox-iso: Starting the virtual machine...
    virtualbox-iso: The VM will be run headless, without a GUI. If you want to
    virtualbox-iso: view the screen of the VM, connect via VRDP without a password to
    virtualbox-iso: 127.0.0.1:5921
==> virtualbox-iso: Waiting 10s for boot...
==> virtualbox-iso: Typing the boot command...
==> virtualbox-iso: Waiting for SSH to become available...
==> virtualbox-iso: Connected to SSH!
==> virtualbox-iso: Uploading VirtualBox version info (5.0.20)
==> virtualbox-iso: Uploading VirtualBox guest additions ISO...
==> virtualbox-iso: Provisioning with shell script: scripts/base.sh
==> virtualbox-iso: Provisioning with shell script: scripts/vagrant.sh
    virtualbox-iso: % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    virtualbox-iso: Dload  Upload   Total   Spent    Left  Speed
    virtualbox-iso: 100   409  100   409    0     0   1682      0 --:--:-- --:--:-- --:--:--  1690
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
    virtualbox-iso: Resolving Dependencies
    virtualbox-iso: --> Running transaction check
    virtualbox-iso: ---> Package kernel.x86_64 0:3.10.0-327.el7 will be erased
    virtualbox-iso: --> Finished Dependency Resolution
    virtualbox-iso:
    virtualbox-iso: Dependencies Resolved
    virtualbox-iso:
    virtualbox-iso: ================================================================================
    virtualbox-iso: Package       Arch          Version                 Repository            Size
    virtualbox-iso: ================================================================================
    virtualbox-iso: Removing:
    virtualbox-iso: kernel        x86_64        3.10.0-327.el7          @anaconda/7.2        136 M
    virtualbox-iso:
    virtualbox-iso: Transaction Summary
    virtualbox-iso: ================================================================================
    virtualbox-iso: Remove  1 Package
    virtualbox-iso:
    virtualbox-iso: Installed size: 136 M
    virtualbox-iso: Downloading packages:
    virtualbox-iso: Running transaction check
    virtualbox-iso: Running transaction test
    virtualbox-iso: Transaction test succeeded
    virtualbox-iso: Running transaction
    virtualbox-iso: Erasing    : kernel-3.10.0-327.el7.x86_64                                 1/1
    virtualbox-iso: Verifying  : kernel-3.10.0-327.el7.x86_64                                 1/1
    virtualbox-iso:
    virtualbox-iso: Removed:
    virtualbox-iso: kernel.x86_64 0:3.10.0-327.el7
    virtualbox-iso:
    virtualbox-iso: Complete!
    virtualbox-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    virtualbox-iso: Resolving Dependencies
    virtualbox-iso: --> Running transaction check
    virtualbox-iso: ---> Package kernel-devel.x86_64 0:3.10.0-327.el7 will be erased
    virtualbox-iso: --> Finished Dependency Resolution
    virtualbox-iso:
    virtualbox-iso: Dependencies Resolved
    virtualbox-iso:
    virtualbox-iso: ================================================================================
    virtualbox-iso: Package            Arch         Version              Repository           Size
    virtualbox-iso: ================================================================================
    virtualbox-iso: Removing:
    virtualbox-iso: kernel-devel       x86_64       3.10.0-327.el7       @anaconda/7.2        33 M
    virtualbox-iso:
    virtualbox-iso: Transaction Summary
    virtualbox-iso: ================================================================================
    virtualbox-iso: Remove  1 Package
    virtualbox-iso:
    virtualbox-iso: Installed size: 33 M
    virtualbox-iso: Downloading packages:
    virtualbox-iso: Running transaction check
    virtualbox-iso: Running transaction test
    virtualbox-iso: Transaction test succeeded
    virtualbox-iso: Running transaction
    virtualbox-iso: Erasing    : kernel-devel-3.10.0-327.el7.x86_64                           1/1
    virtualbox-iso: Verifying  : kernel-devel-3.10.0-327.el7.x86_64                           1/1
    virtualbox-iso:
    virtualbox-iso: Removed:
    virtualbox-iso: kernel-devel.x86_64 0:3.10.0-327.el7
    virtualbox-iso:
    virtualbox-iso: Complete!
    virtualbox-iso: Loaded plugins: product-id, search-disabled-repos, subscription-manager
    virtualbox-iso: Cleaning repos: rhel-7-server-optional-rpms rhel-7-server-rpms
    virtualbox-iso: : rhel-ha-for-rhel-7-server-rpms rhel-rs-for-rhel-7-server-rpms
    virtualbox-iso: : rhel-server-rhscl-7-rpms
    virtualbox-iso: Cleaning up everything
==> virtualbox-iso: Provisioning with shell script: scripts/zerodisk.sh
    virtualbox-iso: dd: error writing ‘/EMPTY’: No space left on device
    virtualbox-iso: 37595+0 records in
    virtualbox-iso: 37594+0 records out
    virtualbox-iso: 39420182528 bytes (39 GB) copied, 129.526 s, 304 MB/s
==> virtualbox-iso: Gracefully halting virtual machine...
==> virtualbox-iso: Preparing to export machine...
    virtualbox-iso: Deleting forwarded port mapping for the communicator (SSH, WinRM, etc) (host port 3936)
==> virtualbox-iso: Exporting virtual machine...
    virtualbox-iso: Executing: export packer-virtualbox-iso-1479327412 --output output-virtualbox-iso/packer-virtualbox-iso-1479327412.ovf
==> virtualbox-iso: Unregistering and deleting virtual machine...
==> virtualbox-iso: Running post-processor: vagrant
==> virtualbox-iso (vagrant): Creating Vagrant box for 'virtualbox' provider
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso/packer-virtualbox-iso-1479327412-disk1.vmdk
    virtualbox-iso (vagrant): Copying from artifact: output-virtualbox-iso/packer-virtualbox-iso-1479327412.ovf
    virtualbox-iso (vagrant): Renaming the OVF to box.ovf...
    virtualbox-iso (vagrant): Compressing: Vagrantfile
    virtualbox-iso (vagrant): Compressing: box.ovf
    virtualbox-iso (vagrant): Compressing: metadata.json
    virtualbox-iso (vagrant): Compressing: packer-virtualbox-iso-1479327412-disk1.vmdk
Build 'virtualbox-iso' finished.
```
