input('tomcat_service_name')= input(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  value: 'tomcat'
)

TOMCAT_CONF_SERVER= input(
  'tomcat_conf_server',
  description: 'Path to tomcat server.xml',
  value: '/usr/share/tomcat/conf/server.xml'
)

input('tomcat_app_dir')= input(
  'tomcat_app_dir',
  description: 'location of tomcat app directory',
  value: '/var/lib/tomcat'
)

TOMCAT_CONF_WEB= input(
  'tomcat_conf_web',
  description: 'location of tomcat web.xml',
  value: '/usr/share/tomcat/conf/web.xml'
)

input('tomcat_home')= input(
  'tomcat_home',
  description: 'location of tomcat home directory',
  value: '/usr/share/tomcat'
)



control "M-10.5" do
  title "10.5 Rename the manager application (Scored)"
  desc  "The manager application allows administrators to manage Tomcat
remotely via a web interface. The manager application should be renamed to make
it harder for attackers or automated scripts to locate. Obscurity can be
helpful when used with other security measures. By relocating the manager
applications, an attacker will need to guess its location rather than simply
navigate to the standard location in order to carry out an attack. "
  impact 0.5
  tag "ref": "1. https://www.owasp.org/index.php/Securing_tomcat"
  tag "severity": "medium"
  tag "cis_id": "10.5"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  desc 'check', "Ensure $CATALINA_HOME/conf/Catalina/localhost/manager.xml,

$CATALINA_HOME/webapps/host-manager/manager.xml,
$CATALINA_HOME/webapps/manager and $CATALINA_HOME/webapps/manager do not
exsist.
"
  desc 'fix', "Perform the following to rename the manager application: Rename
the manager application XML file:
# mv $CATALINA_HOME/webapps/host-manager/manager.xml \\
$CATALINA_HOME/webapps/host-manager/new-name.xml Update the docBase attribute
within $CATALINA_HOME/webapps/host-manager/newname.xml to
${catalina.home}/webapps/new-name Move $CATALINA_HOME/webapps/manager to
$CATALINA_HOME/webapps/newname
# mv $CATALINA_HOME/webapps/manager $CATALINA_HOME/webapps/new-name
"
  desc 'default value', "The default name of the manager application is
“manager\" and is located at:\n$CATALINA_HOME/webapps/manager\n\n"

  begin
    man_dir = command("find #{input('tomcat_home')}/webapps/ -name manager")
    man_xml = command("find #{input('tomcat_home')}/webapps/ -name manager.xml")
    man_local_xml = command("find #{input('tomcat_home')}/conf/Catalina/localhost/ - name manager.xml")

    describe man_dir do
      its('stdout') { should_not include 'manager'}
    end
    describe man_xml do
      its('stdout') { should_not include 'manager.xml'}
    end
    describe man_local_xml do
      its('stdout') { should_not include 'manager.xml'}
    end
  end
end
