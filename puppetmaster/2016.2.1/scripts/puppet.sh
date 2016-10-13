curl -o /home/vagrant/puppet-enterprise-2016.2.1-el-6-x86_64.tar.gz https://s3.amazonaws.com/pe-builds/released/2016.2.1/puppet-enterprise-2016.2.1-el-6-x86_64.tar.gz
tar zxvf /home/vagrant/puppet-enterprise-2016.2.1-el-6-x86_64.tar.gz
/home/vagrant/puppet-enterprise-2016.2.1-el-6-x86_64/puppet-enterprise-installer -c /tmp/puppetmaster.conf

# autosign all certs
echo '*' >> /etc/puppetlabs/puppet/autosign.conf

# Invoke 1st puppet run to complete the install
/usr/local/bin/puppet agent -t

# Update r10k & Install ruby gems for classifications.rb (refer wwt-puppet-control production branch in scripts dir)
/opt/puppetlabs/puppet/bin/gem update r10k
/opt/puppetlabs/puppet/bin/gem install puppetclassify
/opt/puppetlabs/puppet/bin/gem install mongo

# Setup access to github for root and pe-git; creates .ssh/known_hosts
/usr/bin/ssh -oStrictHostKeyChecking=no github.wwt.com
/bin/su -lc "ssh -oStrictHostKeyChecking=no github.wwt.com" pe-git

# Copy github keys into pe-git home dir; referenced by r10k.yaml
/bin/mv /tmp/id_rsa* /home/pe-git/.ssh
/bin/chmod 700 /home/pe-git/.ssh/id_rsa

# Copy temp r10k.yaml in order to deploy production; subsequent puppet run will overwrite via pe_r10k classification
/bin/mv /tmp/r10k.yaml /etc/puppetlabs/r10k/r10k.yaml

# Deploy production and vgt environments to puppetmaster
/usr/local/bin/r10k deploy environment production -pv -c /etc/puppetlabs/r10k/r10k.yaml

# Import classifications from MongoDB
/opt/puppetlabs/puppet/bin/ruby /etc/puppetlabs/code/environments/production/scripts/classifications.rb -i

# Invoke 2nd puppet run to setup hiera and tune JVM for low memory vagrant VM
# Run of Puppet configuration client already in progress; waiting 5 seconds until retry
while :
do
 if [ ! -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; then
   /usr/local/bin/puppet agent -t
   break
 fi
 sleep 5
done

# profile::wwt_hiera generates keys upon force puppet run above; trash these
# copy insecure vagrant eyaml private/public keys
/bin/mv -f /tmp/*.pem /etc/puppetlabs/puppet/keys/

# Set PATH
/bin/sed -i '/^PATH/c PATH=\$PATH:/opt/puppetlabs/puppet/bin:/etc/puppetlabs/code/environments/production/scripts:/opt/puppetlabs/bin:/vagrant/files/' /root/.bash_profile
