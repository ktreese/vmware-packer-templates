#!/bin/bash -eux
# Based off the great "Preparing Linux Template VMs"
# (http://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/) article
# by Bob Plankers, thanks Bob!

# yum update is run in %post; clean up old kernel remnants
if [ $(rpm -qa | grep "^kernel-[0-9]" | wc -l) -eq 2 ]; then
  yum -y erase kernel-3.10.0-327.el7.x86_64
  yum -y erase kernel-devel-3.10.0-327.el7.x86_64
fi

CLEANUP_PAUSE=${CLEANUP_PAUSE:-0}
echo "==> Pausing for ${CLEANUP_PAUSE} seconds..."
sleep ${CLEANUP_PAUSE}

echo "==> Cleaning up yum cache"
/usr/bin/yum clean all

echo "==> Force logs to rotate"
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz

echo "==> Clear audit log and wtmp"
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp

echo "==> Remove the traces of the template MAC address and UUIDs"
/bin/sed -i '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-*

echo "==> Cleaning up tmp"
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

echo "==> Remove the SSH host keys"
/bin/rm -f /etc/ssh/*key*

echo "==> Remove the root user’s shell history"
/bin/rm -f ~root/.bash_history
unset HISTFILE

echo "==> yum -y clean all"
yum -y clean all

echo "==> Zero out the free space to save space in the final image"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quit too early before the large files are deleted
sync
