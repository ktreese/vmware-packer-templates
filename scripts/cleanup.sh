if [ $(rpm -qa | grep "^kernel-[0-9]" | wc -l) -eq 2 ]; then
  yum -y erase kernel-3.10.0-327.el7.x86_64
  yum -y erase kernel-devel-3.10.0-327.el7.x86_64
fi
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*
rm -rf /home/vagrant/puppet*
