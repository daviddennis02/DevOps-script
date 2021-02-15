#!/bin/bash

#Confirm Security Enhanced Linux (SELinux) is installed
sudo dpkg -l selinux*

# Perform these steps to install the pre-requisite packages.
sudo apt-get update
sudo apt-get install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.4 libgd-dev

# Downloading the Source
cd /tmp
echo "Downloading Nagios source file"
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz
tar xzf nagioscore.tar.gz

# Compile
cd /tmp/nagioscore-nagios-4.4.5/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
echo "Compiling Nagioscore"
sudo make all

# Create User And Group: This creates the nagios user and group. The www-data user is also added to the nagios group.
echo "Creating User and Groups"
sudo make install-groups-users
sudo usermod -a -G nagios www-data

# Install Binaries: This step installs the binary files, CGIs, and HTML files.
echo "Installing Binaries"
sudo make install

# Install Service / Daemon: This installs the service or daemon files and also configures them to start on boot.
echo "Installing Daemon"
sudo make install-daemoninit

# Install Configuration Files: This installs the *SAMPLE* configuration files. These are required as Nagios needs some configuration files to allow it to start.
sudo make install-config

# Install Apache Config Files: This installs the Apache web server configuration files and configures Apache settings.
echo "Installing Apache Config files"
sudo make install-webconf
sudo a2enmod rewrite
sudo a2enmod cgi

# Configure Firewall: You need to allow port 80 inbound traffic on the local firewall so you can reach the Nagios Core web interface.
echo "Configuring firewall to allow inbound traffic"
sudo ufw allow Apache
sudo ufw reload

# Create nagiosadmin User Account: You'll need to create an Apache user account to be able to log into Nagios.
# The following command will create a user account called nagiosadmin and you will be prompted to provide a password for the account.
echo "Creating an Apache User Account <Nagiosadmin>"
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Start Apache Web Server
echo "Starting Apache Web Server"
sudo systemctl start nagios.service

# Test Nagios
echo "Point your web browser to the ip address or FQDN of your Nagios Core server, for example:"
echo "http://<ip-address>/nagios"

# Installing The Nagios Plugins : Nagios Core needs plugins to operate properly. The
echo "Installing The Nagios Plugins"

# Installing Pre-requisite packages
sudo apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

# Downloading The Source
echo "Downloading The Source"
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz

# Compile + Install
echo "Compile and  Install Nagios Plugin"
cd /tmp/nagios-plugins-release-2.2.1/
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install

# Test Plugins
echo "Point your web browser to the ip address or FQDN of your Nagios Core server, for example:"
echo "http://<ip-address>/nagios"

# Hint to start,stop,restart,check Nagios status
echo "Use the following commands to start,stop,restart,check Nagios service status"
echo "sudo systemctl start nagios.service || sudo systemctl stop nagios.service || sudo systemctl restart nagios.service || sudo systemctl status nagios.service"