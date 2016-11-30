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
