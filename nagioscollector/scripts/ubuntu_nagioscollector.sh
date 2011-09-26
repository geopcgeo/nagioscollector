#!/bin/sh
#This will install appfirst collector.
collector_url=$1
sudo wget $collector_url
sudo dpkg -i appfirst*.deb
sudo /etc/init.d/afcollector restart
echo "Nagios Collector Installed Successfully"