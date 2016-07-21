yum -y install make gcc gcc-c++ kernel-devel-`uname -r` perl git bzip2

# set MOTD w/puppet console access information
cat << MOTD > /etc/motd

 __          ___          _________    _____           _    ____   _____ 
 \ \        / | \        / /__   __|  / ____|         | |  / __ \ / ____|
  \ \  /\  / / \ \  /\  / /   | |    | |     ___ _ __ | |_| |  | | (___  
   \ \/  \/ /   \ \/  \/ /    | |    | |    / _ \ '_ \| __| |  | |\___ \ 
    \  /\  /     \  /\  /     | |    | |___|  __/ | | | |_| |__| |____) |
     \/  \/       \/  \/      |_|     \_____\___|_| |_|\__|\____/|_____/ 
                                                                         
MOTD

# set puppetmaster in /etc/hosts or puppet will fail to install during invocation of puppet.sh
sed -i -e 's/127.0.0.1   /127.0.0.1   puppetmaster /' /etc/hosts

# Set pretty prompt
curl -so /etc/profile.d/prompt.sh https://gist.githubusercontent.com/ktreese/1ad2dc99aa2840b9e80d/raw/d37451ffc0f6ea54d6ba046ea661f8893744b16f/prompt.sh
sed -i -e 's/STLPUG/WWT/g' /etc/profile.d/prompt.sh
