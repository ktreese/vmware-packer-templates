# set MOTD w/puppet console access information
cat << MOTD > /etc/motd

  _____          _   _    _       _     ______ 
 |  __ \        | | | |  | |     | |   |____  |
 | |__) |___  __| | | |__| | __ _| |_      / / 
 |  _  // _ \/ _\` | |  __  |/ _\` | __|    / /  
 | | \ \  __/ (_| | | |  | | (_| | |_    / /   
 |_|  \_\___|\__,_| |_|  |_|\__,_|\__|  /_/    

MOTD

# Set pretty prompt; borrow from STLPUG and change prompt prefix
curl -so /etc/profile.d/prompt.sh https://gist.githubusercontent.com/ktreese/1ad2dc99aa2840b9e80d/raw/d37451ffc0f6ea54d6ba046ea661f8893744b16f/prompt.sh
sed -i -e 's/STLPUG/3031/g' /etc/profile.d/prompt.sh
