
class nagioscollector::install	{
	case $operatingsystem  {
             
			 debian:
				{
				package { [ "nagios-nrpe-server" ]:
                ensure => present,
					}
			#	exec { "nagioscollector-installation":
			#	command =>"/etc/puppet/modules/nagioscollector/scripts/ubuntu_nagioscollector.sh $collector_url",
			#	logoutput => true,
			#		}
				}
			ubuntu:
				{
				package { [ "nagios-nrpe-server" ]:
                ensure => present,
					}
			#	exec { "nagioscollector-installation":
			#	command =>"/etc/puppet/modules/nagioscollector/scripts/ubuntu_nagioscollector.sh $collector_url",
			#	logoutput => true,
			#		}
				}
			default:				
				{
				service { [ "nrpe" ]:
                ensure => running,
					}
			#	exec { "nagioscollector-installation":
			#	command =>"/etc/puppet/modules/nagioscollector/scripts/centos_nagioscollector.sh $collector_url",
			#	logoutput => true,
			#		}
				}
			}
		}

class nagioscollector::checkhttp {
			exec { "adding-check_http":
			command =>"/etc/puppet/modules/nagioscollector/scripts/check_http.sh $url_tocheck",
			logoutput => true,
			require => Class ["nagioscollector::install"],
			}
		}

class nagioscollector::checkmysqlhealth {
			exec { "adding-check_mysql_health":
			command =>"/etc/puppet/modules/nagioscollector/scripts/check_mysql_health.sh $mysql_username '$mysql_password'",
			logoutput => true,
			require => Class ["nagioscollector::install"],
			}
		}
class nagioscollector::checkapache2 {
			exec { "adding-check_apache2":
			command =>"/etc/puppet/modules/nagioscollector/scripts/check_apache2.sh",
			logoutput => true,
			require => Class ["nagioscollector::install"],
			}
		}
class nagioscollector::checktotalapacheconn {
			exec { "adding-check_total_apache_conn":
			command =>"/etc/puppet/modules/nagioscollector/scripts/check_total_apache_conn.sh",
			logoutput => true,
			require => Class ["nagioscollector::install"],
			}
		}		
		
		
		
		
			
class nagioscollector {
		include nagioscollector::install, nagioscollector::checkhttp, nagioscollector::checkmysqlhealth, nagioscollector::checkapache2, nagioscollector::checktotalapacheconn
		}
