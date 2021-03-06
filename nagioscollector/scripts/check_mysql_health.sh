#!/bin/sh
#This will install and  configure check_mysql_health nagios plugin.
mysql_username=$1
mysql_password=$2
#Step 1: GRANT permission
mysql -u root -e "GRANT SELECT ON *.* TO nagios@'localhost' IDENTIFIED BY 'nagios';"
#Step 2: Installation check_mysql_health
wget http://labs.consol.de/wp-content/uploads/2011/08/check_mysql_health-2.1.7.tar.gz
sudo tar -xvf check_mysql_health-2.1.7.tar.gz
sudo cd check_mysql_health-2.1.7
sudo ./configure
sudo make
sudo make install
#Step 3: Configuration of plugin to have necessary metrics
cat /etc/puppet/modules/nagioscollector/files/check_mysql_health_commands.txt >> /etc/nagios/nrpe.cfg
sudo /etc/init.d/afcollector restart
echo "Configured check_mysql_health nagios plugin"
