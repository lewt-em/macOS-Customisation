#!/bin/bash

######################
### MKCERT Install ###
######################
# Use this script as Jamf Self-Service policy
# Requires homebrew
# Requires admin privilages to install from Jamf

# Get Current User
currentuser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
# su -l "$currentuser" -c "security authorizationdb write com.apple.trust-settings.admin allow"

# Install mkcert from brew
su -l "$currentuser" -c "brew install mkcert"

# Generate CA Store for mkcert (requires admin credentials)
/opt/homebrew/Cellar/mkcert/1.4.4/bin/mkcert -install

# Generate key/cert files in /Users/$currentuser
su -l "$currentuser" -c "mkcert -key-file key.pem -cert-file cert.pem localhost"

# Set file permissions for rw to all
chmod 777 /Users/$currentuser/key.pem
chmod 777 /Users/$currentuser/cert.pem

exit 0
