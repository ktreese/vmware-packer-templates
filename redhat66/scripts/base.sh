yum -y install perl

# set MOTD w/puppet console access information
cat << MOTD > /etc/motd
      _   _                   
     | | | |                  
  ___| |_| |_ __  _   _  __ _ 
 / __| __| | '_ \| | | |/ _\` |
 \__ \ |_| | |_) | |_| | (_| |
 |___/\__|_| .__/ \__,_|\__, |
           | |           __/ |
           |_|          |___/ 

Console Access:
  https://localhost:1443
  username: admin
  password: plstlpug

MOTD

# set puppetmaster in /etc/hosts or puppet will fail to install during invocation of puppet.sh
sed -i -e 's/127.0.0.1   /127.0.0.1   puppetmaster /' /etc/hosts

# Set pretty prompt
curl -so /etc/profile.d/prompt.sh https://gist.githubusercontent.com/ktreese/1ad2dc99aa2840b9e80d/raw/d37451ffc0f6ea54d6ba046ea661f8893744b16f/prompt.sh
