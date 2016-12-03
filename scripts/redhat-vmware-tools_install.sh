#!/bin/bash

# open-vm-tools are not supported on RHEL 6; however, this package is available from the EPEL repository.
/usr/bin/curl -ko /tmp/epel.rpm http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
/bin/rpm -ivh /tmp/epel.rpm
/usr/bin/yum -y install open-vm-tools

# clean up
/bin/rpm -e epel-release
rm -f /tmp/epel.rpm
