#!/bin/sh
#This will install appfirst collector.
collector_url=$1
rpm -ihv $collector_url
/etc/init.d/afcollector restart
echo "Nagios Collector Installed Successfully"