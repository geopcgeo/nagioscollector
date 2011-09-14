
class nagioscollector	{
	case $operatingsystem  {
             
			 debian:
				{
				package { [ "nagios-nrpe-server" ]:
                ensure => present,
					}
				exec { "password":
				command =>"/etc/puppet/modules/nagioscollector/scripts/ubuntu_nagioscollector.sh $mysql_username $mysql_password $url_tocheck ",
					}
				}
			ubuntu:
				{
				package { [ "nagios-nrpe-server" ]:
                ensure => present,
					}
				exec { "password":
				command =>"/etc/puppet/modules/nagioscollector/scripts/ubuntu_nagioscollector.sh $mysql_username $mysql_password $url_tocheck ",
					}
				}
			default:				
				{
				service { [ "nrpe" ]:
                ensure => present,
					}
				exec { "password":
				command =>"/etc/puppet/modules/nagioscollector/scripts/centos_nagioscollector.sh $mysql_username $mysql_password $url_tocheck ",
					}
				}
			}
	}