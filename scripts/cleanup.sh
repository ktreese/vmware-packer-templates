if [ $(rpm -qa | grep "^kernel-[0-9]" | wc -l) -eq 2 ]; then
  yum -y erase kernel-2.6.32-431.el6.x86_64
  yum -y erase kernel-devel-2.6.32-431.el6.x86_64
fi
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*
rm -rf /home/vagrant/puppet*
