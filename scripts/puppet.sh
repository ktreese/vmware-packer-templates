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

# set IP in /etc/hosts so puppet install succeeds:
/bin/echo "$(/sbin/ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') $HOSTNAME" >> /etc/hosts

curl -o /home/vagrant/puppet-enterprise-2016.4.2-el-6-x86_64.tar.gz https://s3.amazonaws.com/pe-builds/released/2016.4.2/puppet-enterprise-2016.4.2-el-6-x86_64.tar.gz
tar zxvf /home/vagrant/puppet-enterprise-2016.4.2-el-6-x86_64.tar.gz
/home/vagrant/puppet-enterprise-2016.4.2-el-6-x86_64/puppet-enterprise-installer -c /tmp/puppetmaster.conf

# autosign all certs
echo '*' >> /etc/puppetlabs/puppet/autosign.conf

# Invoke 1st puppet run to complete the install
run_puppet

# Update r10k & Install ruby gems for classifications.rb (refer wwt-puppet-control production branch in scripts dir)
/opt/puppetlabs/puppet/bin/gem update r10k

# Invoke 2nd puppet run to setup hiera, the pe_repos, and tune JVM for low memory vagrant VM
run_puppet

# Set PATH
/bin/sed -i '/^PATH/c PATH=\$PATH:/opt/puppetlabs/puppet/bin:/etc/puppetlabs/code/environments/production/scripts:/opt/puppetlabs/bin:/vagrant/files/' /root/.bash_profile

# Remove added hosts entry
/bin/sed -i -e "/$HOSTNAME/d" /etc/hosts
