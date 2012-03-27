## Setting up Shibboleth sp Server

- [Setting up Apache Httpd Server](../System Operations \(SysOps\)/Setting up Apache Httpd Server.md)

### Shibboleth IdP Installation:

We can install Shibboleth SP from RPMs on a CentOS Operating System with hostname "sp.netspective.com"

The root of the repository tree for Shibboleth can be found at http://download.opensuse.org/repositories/security://shibboleth/ with each supported OS in its own subdirectory. Each subdirectory is the root of a yum repository and contains a definition file named security:shibboleth.repo.

Open the file CentOS-Base.repo residing at /etc/yum.repos.d/ directory:

	vi /etc/yum.repos.d/CentOS-Base.repo


Add the following lines at the end of the file:

	#adding shibbolethSP repos
	[security_shibboleth]
	name=Shibboleth (CentOS_5)
	type=rpm-md
	baseurl=http://download.opensuse.org/repositories/security:/shibboleth/CentOS_5/
	gpgcheck=1
	gpgkey=http://download.opensuse.org/repositories/security:/shibboleth/CentOS_5/
	repodata/repomd.xml.key
	enabled=1

Now run the following command to install SP:

	# yum install shibboleth

Now open httpd.conf file located at /etc/httpd/conf/ directory and make the following changes:

	vi /etc/httpd/conf/httpd.conf

1. Change the ServerName directive to the server name of your SP sp.netspective.com
1. To ensure that there is no resource mapping errors while running the SP, the UseCanonicalName directive should be set to On.


Open shibboleth2.xml file (at /etc/shibboleth/) to change the entityID:

	vi /etc/shibboleth/shibboleth2.xml

Change the ApplicationDefaults entityID to match your server and remove persistent-id & targeted-id from REMOTE_USER

	<ApplicationDefaults entityID="https://sp.netspective.com/shibboleth" REMOTE_USER="eppn">

Restart Apache:

	/etc/init.d/httpd restart

The shibd daemon must be independently started and run in order to handle requests

	/etc/init.d/shibd start

Configure shibd service to be started at runlevel.

	chkconfig shibd on


