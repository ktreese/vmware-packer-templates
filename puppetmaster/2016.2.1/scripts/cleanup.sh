yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*
rm -rf /home/vagrant/puppet*
cat /dev/null > /var/log/wtmp
