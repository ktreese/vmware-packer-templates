run_puppet() {
  # Run of Puppet configuration client already in progress; waiting 5 seconds until retry
  while :
  do
   if [ ! -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; then
     /usr/local/bin/puppet agent -t
     break
   fi
   sleep 5
  done
}

pe_installer='puppet-enterprise-2016.5.1-el-7-x86_64.tar.gz'

# set IP in /etc/hosts so puppet install succeeds:
/bin/echo "$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME" >> /etc/hosts

curl -o /home/vagrant/$pe_intaller https://s3.amazonaws.com/pe-builds/released/2016.5.1/$pe_installer
tar zxvf /home/vagrant/$pe_installer
/home/vagrant/puppet-enterprise-2016.5.1-el-7-x86_64/puppet-enterprise-installer -c /tmp/puppetmaster.conf

# autosign all certs
echo '*' >> /etc/puppetlabs/puppet/autosign.conf

# Invoke 1st puppet run to complete the install
run_puppet

# Update r10k & Install ruby gems for classifications.rb (refer wwt-puppet-control production branch in scripts dir)
/opt/puppetlabs/puppet/bin/gem update r10k
#/opt/puppetlabs/puppet/bin/gem install puppetclassify
#/opt/puppetlabs/puppet/bin/gem install mongo

## Import classifications from MongoDB
#/opt/puppetlabs/puppet/bin/ruby /etc/puppetlabs/code/environments/production/scripts/classifications.rb -i

# Invoke 2nd puppet run to setup hiera, the pe_repos, and tune JVM for low memory vagrant VM
run_puppet

## profile::wwt_hiera generates keys upon force puppet run above; trash these
## copy insecure vagrant eyaml private/public keys
#/bin/mv -f /tmp/*.pem /etc/puppetlabs/puppet/keys/

# Set PATH
/bin/sed -i '/^PATH/c PATH=\$PATH:/opt/puppetlabs/puppet/bin:/etc/puppetlabs/code/environments/production/scripts:/opt/puppetlabs/bin:/vagrant/files/' /root/.bash_profile

# Remove added hosts entry
/bin/sed -i -e "/$HOSTNAME/d" /etc/hosts
