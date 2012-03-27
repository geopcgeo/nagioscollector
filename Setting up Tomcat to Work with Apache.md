#Setting up Apache Tomcat to work with Apache Server

We are using **mod_jk** Tomcat-Apache plug-in that handles the communication between Tomcat and Apache.

#### Prerequisites
- [Setup Apache Tomcat](../System Operations \(SysOps\)/Setting up Apache Tomcat.md)
- [Setting up Apache Httpd Server](../System Operations \(SysOps\)/Setting up Apache Httpd Server.md)

Install the GNU compilers gcc and g++, make utility to maintain groups of programs and httpd-devel package with the following command in rpm based linux.

	yum install gcc* gcc-c++ make automake httpd-devel 

#### Installation and configuration

Ensure Apache HTTP Server is not running
	
	/etc/init.d/httpd stop

Download and extract Tomcat Connector to the following under /root

	cd /root/
	wget http://mirrors.kahuki.com/apache//tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.32-src.tar.gz
	tar -xvf tomcat-connectors-1.2.32-src.tar.gz
	cd /root/tomcat-connectors-1.2.32-src/native/

Build and install with the following command

	./configure --with-apxs=/usr/sbin/apxs; make; make install

Change permission of loaded module mod_jk.so

	chmod 755 /usr/lib64/httpd/modules/mod_jk.so

Create mod_jk.conf file in apache httpd server.

	vi /etc/httpd/conf.d/mod_jk.conf

Copy and paste below lines.

	<IfModule !mod_jk.c>
	  LoadModule jk_module "/usr/lib64/httpd/modules/mod_jk.so"
	</IfModule>
	
	JkWorkersFile "/opt/apache-tomcat-6.0.20/conf/jk/workers.properties"
	JkLogFile "/opt/apache-tomcat-6.0.20/logs/mod_jk.log"
	
	JkLogLevel emerg

Open workers.properties file in apache tomcat.

	vi /opt/tomcat/conf/jk/workers.properties

Add ajp13 to workers.list so that the following line becomes:

	worker.list=jk-status, ajp13


In mod_jk.conf and ssl.conf use mod_jk's JkMount directive to assign specific URLs to Tomcat. For example the following directives will send all requests beginning with /idp to the "ajp13" worker.

Open mod_jk.conf in apache server.

	vi /etc/httpd/conf.d/mod_jk.conf

Copy and paste below lines at the end of file.

	JkMount /idp ajp13
	JkMount /idp/* ajp13

Now open ssl.conf file to setup redirection for secure connection

	vi /etc/httpd/conf.d/ssl.conf

Configure mod_ssl by adding the following lines near the end, just before the closing </VirtualHost>.

	JkMount /idp ajp13
	JkMount /idp/* ajp13

Restart tomcat and apache

	catalina.sh stop
	catalina.sh	start
	/etc/init.d/httpd restart
	
