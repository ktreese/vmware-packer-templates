yum -y install perl

# set MOTD w/puppet console access information
cat << MOTD > /etc/motd

                    _                                  _                         _   
                   | |                                | |                       | |  
 __      ___      _| |_   _ __  _   _ _ __  _ __   ___| |_ __ _  __ _  ___ _ __ | |_ 
 \ \ /\ / | \ /\ / / __| | '_ \| | | | '_ \| '_ \ / _ \ __/ _\` |/ _\` |/ _ \ '_ \| __|
  \ V  V / \ V  V /| |_  | |_) | |_| | |_) | |_) |  __/ || (_| | (_| |  __/ | | | |_ 
   \_/\_/   \_/\_/  \__| | .__/ \__,_| .__/| .__/ \___|\__\__,_|\__, |\___|_| |_|\__|
                         | |         | |   | |                   __/ |               
                         |_|         |_|   |_|                  |___/                

MOTD

# Set pretty prompt; borrow from STLPUG and change prompt prefix
curl -so /etc/profile.d/prompt.sh https://gist.githubusercontent.com/ktreese/1ad2dc99aa2840b9e80d/raw/d37451ffc0f6ea54d6ba046ea661f8893744b16f/prompt.sh
sed -i -e 's/STLPUG/WWT/g' /etc/profile.d/prompt.sh

# Disable annoying RedHat subscription alert upon yum invocation
sed -i -e 's/1/0/' /etc/yum/pluginconf.d/subscription-manager.conf

# Setup use of CentOS repo for package availability; mv from tmp as packer provisioner cannot write to /etc/yum.repos.d
mv /tmp/CentOS-Base.repo /etc/yum.repos.d/
