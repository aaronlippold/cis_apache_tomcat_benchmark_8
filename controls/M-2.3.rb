# -*- encoding : utf-8 -*-
# frozen_string_literal: true

control 'M-2.3' do
  title '2.3 Alter the Advertised server.built Date (Scored)'
  desc  "The server.built date represents the date which Tomcat was compiled
and packaged. This value is presented to Tomcat clients when clients connect to
the server. Altering the server.built string may make it harder for attackers
to fingerprint which vulnerabilities affect the server platform. "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.3'
  tag "cis_control": ['No CIS Control', '6.1']
  tag "cis_level": 2
  desc 'check', "Perform the following to determine if the server.built
value has been changed: Extract the ServerInfo.properties file and examine the
server.built attribute.
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties
$ grep server.built org/apache/catalina/util/ServerInfo.properties
"
  desc 'fix', "Perform the following to alter the server version string that
gets displayed when clients
connect to the server. Extract the ServerInfo.properties file from the
catalina.jar file:
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties Navigate
to the util directory that was created
$ cd org/apache/Catalina/util Open ServerInfo.properties in an editor Update
the server.built attribute in the ServerInfo.properties file.
server.built= Update the catalina.jar with the modified ServerInfo.properties
file.
$ jar uf catalina.jar org/apache/catalina/util/ServerInfo.properties

"
  desc 'default value', "The default value for the server.built attribute is
build date and time. For example, Jul 8\n2008 11:40:35."

  describe command("unzip -p #{input('tomcat_home')}/lib/catalina.jar org/apache/catalina/util/ServerInfo.properties | grep server.built") do
    its('stdout.strip') { should eq input('tomcat_server_built').to_s }
  end
end
