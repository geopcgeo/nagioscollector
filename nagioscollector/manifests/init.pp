class nagioscollector
	{
	package { [ "nagios-nrpe-server" ]:
		ensure => present,
	}
	
	exec { "password":
							command =>"/etc/puppet/modules/nagioscollector/scripts/nagioscollector.sh $mysql_username $mysql_password $url_tocheck ",
							require => Service["nagios3"]
		}
		
	}