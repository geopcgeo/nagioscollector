#!/bin/sh
#This will check the number of connections to port 80.
#Script developed by Geo Citrus Informatics
sudo vi /usr/lib/nagios/plugins/check_total_apache_conn.sh
sudo chmod 755 /usr/lib/nagios/plugins/check_total_apache_conn.sh
cat /etc/puppet/modules/nagioscollector/files/check_total_apache_conn.txt >> /usr/lib/nagios/plugins/check_total_apache_conn.sh
echo "command[check_total_apache_conn]=/usr/lib/nagios/plugins/check_total_apache_conn.sh" >> /etc/nagios/nrpe.cfg
sudo /etc/init.d/afcollector restart
echo "Configured check_total_apache_conn so that it will check the number of connections to port 80"
