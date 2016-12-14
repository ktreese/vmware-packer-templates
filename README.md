# vmware-packer-templates

Builds a VMware virtual machine directly on a VMware vSphere Hypervisor via the [vmware-iso](https://www.packer.io/docs/builders/vmware-iso.html) VMware Packer Builder. Once VMs are created, they may be converted into templates and deployed directly to vSphere via vagrant, using the [vagrant-vsphere](https://github.com/nsidc/vagrant-vsphere) plugin.

##### Branch Descriptions
Each branch represents the OS or application it is named after.  Refer to the usage examples to conduct a build via packer. You'll of course need to plugin your environments specifications for those things I did not parameterize.

- `master:` Contains just the README for now.  Each branch is intended to be long lived for the build it represents

- `redhat6:` Builds a Red Hat 6 virtual machine based off a 6.8 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the Red Hat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.

- `redhat7:` Builds a Red Hat 7 virtual machine based off a 7.2 ISO.  The build applies the latest available patches and package updates (including kernel revisions) via registration with the Red Hat Customer Portal, taking advantage of developer.redhat.com's no-cost Red Hat Enterprise Linux Developer Suite subscription, which includes Red Hat Enterprise Linux Server, and access to the Red Hat Customer Portal for software updates and knowledgebase articles.  This is the same subscription available to enterprise, where the only difference is the no-cost developer suite subscription is self-supported.

- `pe.2016.2.1:` Using the same virtual machine packer build as `redhat6`, this deployment includes an additional puppet shell provisioner to install a base installation/setup of Puppet Enterprise 2016.2.1.

##### Usage Examples:
```
$ packer validate rhel-server-7-x86_64.json      validate template syntax
$ packer build rhel-server-7-x86_64.json         build a RedHat 7 vagrant box
$ add.sh                                         add vagrant box
$ vagrant up                                     boot based of distributed Vagrantfile
$ vagrant ssh                                    ssh into the vagrant machine
```

# Example Run
