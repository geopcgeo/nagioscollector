#!/bin/sh
#This will install and  configure check_mysql_health nagios plugin.
sudo vi /usr/lib/nagios/plugins/check_apache2.sh
sudo chmod 755 /usr/lib/nagios/plugins/check_apache2.sh
cat /etc/puppet/modules/nagioscollector/files/check_apache2.txt >> /usr/lib/nagios/plugins/check_apache2.sh
echo "command[check_apache2]=/usr/lib/nagios/plugins/check_apache2.sh -H localhost -p 80 -t 3 -b /usr/bin" >> /etc/nagios/nrpe.cfg
sudo /etc/init.d/afcollector restart
echo "Configured check_apache2 nagios plugin"
