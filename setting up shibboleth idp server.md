# Setting up Shibboleth IdP Server

- [Setting a CentOS Base Server](../System Operations \(SysOps\)/Setting a Base CentOS Server.md)
- [Setup Java](../System Operations \(SysOps\)/Setting up Java.md)
- [Setup Apache Tomcat](../System Operations \(SysOps\)/Setting up Apache Tomcat.md)
- [Setup ApacheDS](../System Operations \(SysOps\)/Setting up ApacheDS.md)

### Shibboleth IdP Installation:

This section describes the installation and configuration of the Shibboleth IdP on this server with hostname: "idp.netspective.com"

Get the latest Identity Provider software package from the Shibboleth download page (http://www.shibboleth.net/downloads/identity-provider/latest/), you may download to /usr/local/src as:

	cd /usr/local/src
	wget http://www.shibboleth.net/downloads/identity-provider/latest/shibboleth-identityprovider-2.3.6-bin.zip

Make sure you have installed unzip package using the command

	yum install unzip

Extract the shibboleth-identityprovider-2.3.6-bin.zip and make the installer script install.sh executable. The archive will be extracted into the directory shibboleth-identityprovider-2.3.6 as:

	unzip shibboleth-identityprovider-2.3.0-bin.zip
	cd shibboleth-identityprovider-2.3.6
	chmod u+x install.sh

Endorse Xerces (Java parser for XML) and Xalan (Xalan is an XSLT processor for transforming XML documents into HTML, text, or other XML document types) libraries from the Shibboleth IdP source package in TOMCAT_HOME/endorsed. Copy the endorsed directory and the included jar files from the shibboleth-idp source directory to the TOMCAT_HOME directory as:

	cp -r endorsed/ /opt/tomcat

Run the installer script to install IdP as:

	./install.sh

The installer will ask for the installation directory, we can give default and it is /opt/shibboleth-idp and it asks fully qualified hostname for the IdP server, we can give idp.netspective.com during the installation process.Remember the password that you provide for the key store during installation as this password will be used later in configuration.

Note: The installation directory given during installation will be known as IDP_HOME throughout this document.

Set the IDP_HOME environment variable by adding the following to the .bash_profile:

	IDP_HOME=/opt/shibboleth-idp
	export IDP_HOME

Configure JVM memory options for the needs of the IdP web application. The values for memory usage depend on the physical memory of the server. Set Xmx (maximum amount of heap space available to the JVM) to at least 512 MB and XX:MaxPermSize to 128 MB.

Edit the TOMCAT_HOME/bin/catalina.sh file and add the JAVA_OPTS variable as:

	JAVA_OPTS="-Djava.awt.headless=true -Xmx512M -XX:MaxPermSize=128M -Dcom.sun.security.enableCRLDP=true"

Supporting SOAP Endpoints: During certain operations like Attribute Query, Artifact Resolution, and Logout the Shibboleth IdP and SP may communicate directly, as opposed to sending messages via the user’s browser. In order to support these request the IdP needs an additional port (called a Connector within the Tomcat configuration), distinct from the one used by the user (because they have different, mutually exclusive, security requirements). To support SOAP endpoints perform the following steps:

Download tomcat6-dta-ssl-1.0.0.jar from Shibboleth site in to TOMCAT_HOME/lib/ folder.

	cd $TOMCAT_HOME/lib/
	wget http://shibboleth.internet2.edu/downloads/maven2/edu/internet2/middleware/security/tomcat6/tomcat6-dta-ssl/1.0.0/tomcat6-dta-ssl-1.0.0.jar

Include endorsed jar files at the time of tomcat loading. Open $TOMCAT_HOME/conf/catalina.properties file and include ${catalina.home}/endorsed/*.jar in common.loader as follows:

	common.loader=${catalina.home}/lib,${catalina.home}/lib/*.jar,${catalina.home}/endorsed/*.jar



Edd the following connector definition to Tomcat’s TOMCAT_HOME/conf/server.xml file:

				<Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               	maxThreads="150" scheme="https" secure="true"
              	clientAuth="false" sslProtocol="TLS"
                keystoreFile="/opt/shibboleth-idp/credentials/idp.jks"
				keystorePass="password" />

Note: In the keystorePass provide the password that you entered during shibboleth-idp installation.

Note: During the Prerequisite tomcat installation please do the configuration of SSL for tomcat.

Deploy the IdP WAR file, located in IDP_HOME/war/ using a context deployment fragment:
The normal procedure of deploying web applications to Tomcat is by copying the WAR file into the Tomcat webapps/ folder. However, when this procedure is followed Tomcat will explode the war (giving you idp.war and idp/ within webapps/) and then cache another version of the application in work/Catalina/localhost/. This can lead to cases where you copy a new WAR into place but Tomcat continues to use the older version.

To address this issue, it is recommended that you use a context deployment fragment. It means that you use a small bit of XML that tells Tomcat where to get the WAR and provides some properties used when Tomcat load the application. This approach will also prevent those times when you create a new WAR and forget to copy it into Tomcat as this makes Tomcat load the war from IDP_HOME/war/ where the installer places it.

Create and open the file at TOMCAT_HOME/conf/Catalina/localhost/idp.xml as:

	vi /opt/tomcat/conf/Catalina/localhost/idp.xml

Copy the following content to the newly created idp.xml file:

	<Context docBase="/opt/shibboleth-idp/war/idp.war"
	privileged="true" antiResourceLocking="false"
	antiJARLocking="false" unpackWAR="false"
	swallowOutput="true" />

Stop the TOMCAT (if it’s running) and start it again so that it deploy the idp.war

	catalina.sh stop
	catalina.sh start

A quick test at this point:

The IdP can be tested for proper installation and running by accessing the URL: http://idp.netspective.com:8080/idp/profile/Status If you receive an “ok” page, it means everything is okay till now.



Open the handler.xml file in IDP_HOME/conf/ directory and perform the following:

	vi $IDP_HOME/conf/handler.xml

Enable the UsernamePassword login handler in the configuration file by remove the comments around the UsernamePassword <LoginHandler> element. You must comment out the RemoteUser <LoginHandler>element or the authentication will be open for any user. You handler.xml should look like as:

	<!-- Login Handlers -->
	<!--    <ph:LoginHandler xsi:type="ph:RemoteUser">
	        <ph:AuthenticationMethod>urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified</ph:AuthenticationMethod>
	    </ph:LoginHandler>
	    -->
	    <!--  Username/password login handler -->
	
	    <ph:LoginHandler xsi:type="ph:UsernamePassword"
	                  jaasConfigurationLocation="file:///opt/shibboleth-idp/conf/login.config">
	        <ph:AuthenticationMethod>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</ph:AuthenticationMethod>
	    </ph:LoginHandler>

Open the login.config file in IDP_HOME/conf/ directory, at the end of the file you will find ShibUserPassAuth, copy the following inside the ShibUserPassAuth parenthesis with your ldap details and make sure everything else is commented out inside the parenthesis:

	edu.vt.middleware.ldap.jaas.LdapLoginModule required
	        host="idp.netspective.local"
	        port="10389"
	        base="ou=system"
	        ssl="false"
	        subtreeSearch="true"
	        userField="uid"
	        serviceUser="uid=admin,ou=system"
	        serviceCredential="Your Password";
	


