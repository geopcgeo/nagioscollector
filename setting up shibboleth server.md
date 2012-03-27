# Setting up Shibboleth IDP and SP Server







### Metadata Configuration

Metadata plays an important role in identifying and building the trust between an IdP and SP. Unlike IdP installation process the SP installation does not generate default metadata. You have to request a metadata from any pre-existing Federation or create your own by hand. Once you create or acquire metadata for SP, you must supply it to the IdP. Similarly, the IdP MUST supply its metadata to the SP. There are three different methods of supplying metadata to SP/IdP as specified in the url https://wiki.shibboleth.net/confluence/display/SHIB2/Metadata#Metadata-MethodsforSupplyingMetadata. 

We will follow the simple approach; maintaining the metadata in files that you copy to the IdP or SP server to load from the local file system.


At the IdP server copy its metadata file **idp-metadata.xml** located at **/opt/shibboleth-idp/** metadata directory and place it at your SP server at location **/etc/shibboleth/** directory.

Note: You can use below command in idp server to copy metada file to sp server

	scp -r -v /opt/shibboleth-idp/idp-metadata.xml root@sp.netspective.com:/etc/shibboelth/

Now from idp server download metadata of sp.netspective.com server.

	cd $HOME
	wget http://sp.netspective.com/Shibboleth.sso/Metadata

Move the metadata file to /opt/shibboleth-idp/metadata with file name sp-metadata.xml

mv Metadata /opt/shibboleth-idp/metadata/sp-metadata.xml


#### Configuration to reflect the metadata

Open the relying-party.xml file (at /opt/shibboleth-idp/conf/)

	vi /opt/shibboleth-idp/conf/relying-party.xml

Add the following to the relying-party.xml file just after the IdP’s own metadata is defined:

	<!-- Load the SP's metadata.  -->
	<metadata:MetadataProvider xsi:type="FilesystemMetadataProvider"
	xmlns="urn:mace:shibboleth:2.0:metadata" id="SPMETADATA"
	metadataFile="/opt/shibboleth-idp/metadata/sp-metadata.xml" />
	</metadata:MetadataProvider>

At the SP server edit the shibboleth2.xml file (at /etc/shibboleth/) to effect the following changes:

	vi /etc/shibboleth/shibboleth2.xml

Verify the ApplicationDefaults entityID to match your server:

	<ApplicationDefaults entityID="https://sp.netspective.com/shibboleth" REMOTE_USER="eppn">

Configures SSO for your IdP server and remove discoveryProtocol and discoveryURL.

	<SSO entityID="https://idp.netspective.com/idp/shibboleth">
	 SAML2 SAML1 
	</SSO>

Uncomment locally maintained metadata and file name changed to idp-metadata.xml

	<!-- Example of locally maintained metadata. -->
	    <MetadataProvider type="XML" file="idp-metadata.xml"/>

Once you’ve actually configured the SP with its own settings and metadata from at least one IdP, in order to check that the SP is working. Protect a directory by requiring a Shibboleth session. Usually, this is already done by default for the location /secure.



#### Shibboleth IDP and SP on same server.

If we are using idp and sp on same server, then we need some additional configuration in which we need to setup up Apache Tomcat to work with Apache Server.



Please follow below steps while using JkMount directive to assign specific URLs to Tomcat.

Open mod_jk.conf in apache server.

	vi /etc/httpd/conf.d/mod_jk.conf

Copy and paste below lines at the end of file.

	JkMount /shibboleth ajp13
	JkMount /shibboleth/* ajp13
	JkMount /idp ajp13
	JkMount /idp/* ajp13

Now open ssl.conf file to setup redirection for secure connection

	vi /etc/httpd/conf.d/ssl.conf

Configure mod_ssl by adding the following lines near the end, just before the closing </VirtualHost>.

	JkMount /idp ajp13
	JkMount /idp/* ajp13
	JkMount /shibboleth ajp13
	JkMount /shibboleth/* ajp13

Now in same /etc/httpd/conf.d/ssl.conf file, edit ServerName

	ServerName idm.netspective.com:443


Then we need to comment out the 443 port in tomcat. 

vi $TOMCAT_HOME/conf/server.xml

	<!--
	<Connector port="443" protocol="HTTP/1.1" SSLEnabled="true"
	maxThreads="150" scheme="https" secure="true" clientAuth="false"
	sslProtocol="TLS" keystoreFile="/opt/keystore" keystorePass="password" />
	-->


Now restart tomcat and apache

	catalina.sh stop
	catalina.sh	start
	/etc/init.d/httpd restart


**Let’s check it:**

Open a browser at Client machine and type the following URL: https://sp.netspective.com/secure 

You will be redirected to the Shibboleth Login page and enter your user/password that created in your LDAP Server

After successful authentication you will access the resource.






