cThis contains generalized puppet script for the installation and configuration of nagios collector on Linux Operating Systems
*******************************************************************************************

Server Configuration Management Setup
=====================================




For rpm package: (redhat,centos, etc)
-------------------------------------

#Installing git and puppet

yum install git-core puppet

#Configuring ssh public key.

cd $HOME
ssh-keygen -t rsa 
vi .ssh/id_rsa.pub

Paste the ssh key into the GitHub account you'll be using

git clone git@github.com:geopcgeo/nagioscollector.git


#Installation of nagios colletcor.

ln -s /$HOME/nagioscollector /etc/puppet/modules
mkdir /etc/puppet/manifests
cp /etc/puppet/modules/nodes.pp /etc/puppet/manifests/
sudo chmod 755 /etc/puppet/modules/nagioscollector/scripts/*
puppet -v /etc/puppet/manifests/nodes.pp

# Post Installation step need to be done in AppFirst Interface

Go to the Collectors page (under the Administration tab) and on the particular server edit the config file.
Change "/usr/local/nagios/etc/nrpe.cfg" to  "/etc/nagios/nrpe.cfg"
Save and restart collector in shell with command 
sudo /etc/init.d/afcollector restart




For debian package: (ubuntu, debian etc)
----------------------------------------


# Installing git and puppet

sudo apt-get install -y git-core puppet


# Configuring ssh public key.

cd $HOME
sudo ssh-keygen -t rsa 
sudo vi .ssh/id_rsa.pub

# Paste the ssh key into the GitHub account you'll be using

sudo git clone git@github.com:geopcgeo/nagioscollector.git

# Installation of nagios colletcor.

sudo ln -s /$HOME/nagioscollector /etc/puppet/modules
sudo cp /etc/puppet/modules/nodes.pp /etc/puppet/manifests/
sudo chmod 755 /etc/puppet/modules/nagioscollector/scripts/*
sudo puppet -v /etc/puppet/manifests/nodes.pp

# Post Installation step need to be done in AppFirst Interface

Go to the Collectors page (under the Administration tab) and on the particular server edit the config file.
Change "/usr/local/nagios/etc/nrpe.cfg" to  "/etc/nagios/nrpe.cfg"
Save and restart collector in shell with command 
sudo /etc/init.d/afcollector restart

