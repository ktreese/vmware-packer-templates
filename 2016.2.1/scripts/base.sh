yum -y install perl

# set MOTD w/puppet console access information
cat << MOTD > /etc/motd

                    _                                  _                       _            
                   | |                                | |                     | |           
 __      ___      _| |_   _ __  _   _ _ __  _ __   ___| |_ _ __ ___   __ _ ___| |_ ___ _ __ 
 \ \ /\ / | \ /\ / / __| | '_ \| | | | '_ \| '_ \ / _ \ __| '_ \` _ \ / _\` / __| __/ _ \ '__|
  \ V  V / \ V  V /| |_  | |_) | |_| | |_) | |_) |  __/ |_| | | | | | (_| \__ \ ||  __/ |   
   \_/\_/   \_/\_/  \__| | .__/ \__,_| .__/| .__/ \___|\__|_| |_| |_|\__,_|___/\__\___|_|   
                         | |         | |   | |                                              
                         |_|         |_|   |_|                                              


Console Access:
  https://localhost:4443
  username: admin
  password: wwtpuppet

MOTD

# set puppetmaster in /etc/hosts or puppet will fail to install during invocation of puppet.sh
sed -i -e 's/127.0.0.1   /127.0.0.1   puppetmaster puppetmaster.wwt.com puppetmaster.wwt.local /' /etc/hosts

# Set pretty prompt; borrow from STLPUG and change prompt prefix
curl -so /etc/profile.d/prompt.sh https://gist.githubusercontent.com/ktreese/1ad2dc99aa2840b9e80d/raw/d37451ffc0f6ea54d6ba046ea661f8893744b16f/prompt.sh
sed -i -e 's/STLPUG/WWT/g' /etc/profile.d/prompt.sh

# Disable annoying RedHat subscription alert upon yum invocation
sed -i -e 's/1/0/' /etc/yum/pluginconf.d/subscription-manager.conf

# Setup use of CentOS repo for package availability; mv from tmp as packer provisioner cannot write to /etc/yum.repos.d
mv /tmp/CentOS-Base.repo /etc/yum.repos.d/
