#!/bin/sh
#This will check_http nagios plugin.
url_tocheck=$1
echo "command[check_http]=/usr/lib/nagios/plugins/check_http -w 10 -c 15 $url_tocheck" >> /etc/nagios/nrpe.cfg
/etc/init.d/afcollector restart
echo "Configured check_http for $url_tocheck"