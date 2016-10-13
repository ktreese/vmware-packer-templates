yum -y install perl

# set MOTD w/puppet console access information
cat << MOTD > /etc/motd
 __          ___          _________   _____          _ _    _       _   
 \ \        / | \        / /__   __| |  __ \        | | |  | |     | |  
  \ \  /\  / / \ \  /\  / /   | |    | |__) |___  __| | |__| | __ _| |_ 
   \ \/  \/ /   \ \/  \/ /    | |    |  _  // _ \/ _\` |  __  |/ _\` | __|
    \  /\  /     \  /\  /     | |    | | \ \  __/ (_| | |  | | (_| | |_ 
     \/  \/       \/  \/      |_|    |_|  \_\___|\__,_|_|  |_|\__,_|\__|
                                                                        
MOTD

# Set pretty prompt; borrow from STLPUG and change prompt prefix
curl -so /etc/profile.d/prompt.sh https://gist.githubusercontent.com/ktreese/1ad2dc99aa2840b9e80d/raw/d37451ffc0f6ea54d6ba046ea661f8893744b16f/prompt.sh
sed -i -e 's/STLPUG/WWT/g' /etc/profile.d/prompt.sh

# Disable annoying RedHat subscription alert upon yum invocation
sed -i -e 's/1/0/' /etc/yum/pluginconf.d/subscription-manager.conf

# Setup use of CentOS repo for package availability; mv from tmp as packer provisioner cannot write to /etc/yum.repos.d
mv /tmp/media.repo /etc/yum.repos.d/
mv /tmp/CentOS-Base.repo /etc/yum.repos.d/
