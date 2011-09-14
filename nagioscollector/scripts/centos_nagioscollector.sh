#!/bin/sh
#This will install appfirst collector and will configure pooled data on a ubuntu 64 bit OS.


mysql_username=$1
mysql_password=$2
url_tocheck=$3


rpm -ihv http://wwws.appfirst.com/packages/initial/5892/appfirst-x86_64.rpm
echo "command[check_mysql]=/usr/lib/nagios/plugins/check_mysql -u $mysql_username -p $mysql_password" >> /etc/nagios/nrpe.cfg
echo "command[check_http]=/usr/lib/nagios/plugins/check_http -w 10 -c 15 $url_tocheck" >> /etc/nagios/nrpe.cfg
/etc/init.d/afcollector restart
