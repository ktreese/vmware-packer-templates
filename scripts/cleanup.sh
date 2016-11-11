# yum update is run in %post; clean up old kernel remnants
if [ $(rpm -qa | grep "^kernel-[0-9]" | wc -l) -eq 2 ]; then
  rpm -e kernel-2.6.32-573.el6.x86_64
  rpm -e kernel-devel-2.6.32-573.el6.x86_64
fi
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*
rm -rf /home/vagrant/puppet*
cat /dev/null > /var/log/wtmp
