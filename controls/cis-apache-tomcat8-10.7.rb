# frozen_string_literal: true

control 'cis-apache-tomcat8-10.7' do
  title '10.7 Turn off session façade recycling (Scored)'
  desc  "The RECYCLE_FACADES can specify if a new façade will be created for
each request. If a new façade is not created there is a potential for
information leakage from other sessions. When RECYCLE_FACADES is set to false,
Tomcat will recycle the session façade between requests. This will allow for
information leakage between requests. "
  impact 0.5
  ref 'http://tomcat.apache.org/tomcat-8.0-doc/config/systemprops.html'
  ref 'https://tomcat.apache.org/tomcat-8.0-doc/security-howto.html'
  tag "severity": 'medium'
  tag "cis_id": '10.7'
  tag "cis_control": ['No CIS Control', '6.1']
  tag "cis_level": 1
  desc 'check', "Ensure the above parameter is added to the startup script
which by default is located at
$CATALINA_HOME/bin/catalina.sh.
"
  desc 'fix', "Start Tomcat with RECYCLE_FACADES set to true. Add the following
to your startup script.
-Dorg.apache.catalina.connector.RECYCLE_FACADES=true
"
  desc 'default value', "If not specified, the default value of false will be
used.\n"

  cat_prop = tomcat_properties_file.read_content("#{input('tomcat_home')}/conf/catalina.properties")

  describe cat_prop['org.apache.catalina.connector.RECYCLE_FACADES'] do
    it { should cmp 'true' }
  end
end
