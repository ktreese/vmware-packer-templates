#!/bin/bash
cd /var/tmp
tar xfz VMwareTools*.tar.gz
cd /var/tmp/vmware-tools-distrib
ls -la

# from http://www.virtuallyghetto.com/2015/06/automating-silent-installation-of-vmware-tools-on-linux-wautomatic-kernel-modules.html
# If you wish to change which Kernel modules get installed
# The last four entries (yes,no,no,no) map to the following:
#   VMware Host-Guest Filesystem
#   vmblock enables dragging or copying files
#   VMware automatic kernel modules
#   Guest Authentication
# and you can also change the other params as well
sudo cat > /tmp/answer << __ANSWER__
yes
/usr/bin
/etc
/etc/init.d
/usr/sbin
/usr/lib/vmware-tools
yes
/usr/share/doc/vmware-tools
yes
yes
yes
no
yes
no

__ANSWER__

sudo /var/tmp/vmware-tools-distrib/vmware-install.pl < /tmp/answer

cd /var/tmp
rm -rf vmware-tools-distrib
rm -f VMwareTools*.tar.gz
