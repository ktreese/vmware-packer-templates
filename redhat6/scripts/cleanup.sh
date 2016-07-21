yum -y erase kernel-2.6.32-431.el6.x86_64
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*
rm -rf /home/vagrant/puppet*
