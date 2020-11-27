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

TOMCAT_LOGS= input(
  'tomcat_logs',
  description: 'location of tomcat log directory',
  value: '/usr/share/tomcat/logs'
)



control "M-7.6" do
  title "7.6 Ensure directory in logging.properties is a secure location
(Scored)"
  desc  "The directory attribute tells Tomcat where to store logs. The
directory value should be a secure location with restricted access. Securing
the log location will help ensure the integrity and confidentiality of web
application activity records. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "7.6"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  desc 'check', "Review the permissions of the directory specified by the
directory setting to ensure the
permissions are o-rwx and owned by tomcat_admin:tomcat:
# grep directory logging.properties
# ls –ld <log_location>
"
  desc 'fix', "Perform the following: Add the following properties into your
logging.properties file if they do not exist
<application_name>.org.apache.juli.FileHandler.directory=<log_location>
<application_name>.org.apache.juli.FileHandler.prefix=<application_name> Set
the location pointed to by the directory attribute to be owned by
tomcat_admin:tomcat with permissions of o-rwx.
# chown tomcat_admin:tomcat <log_location>
# chmod o-rwx <log_location>
"
  desc 'default value', "The directory location is configured to store logs in
$CATALINA_BASE/logs"

  begin
    log_prop = tomcat_properties_file.read_content("#{input('tomcat_home')}/conf/logging.properties")
    app_dir = command("ls #{input('tomcat_home')}/webapps").stdout.split
    app_prefix = command("ls #{input('tomcat_home')}/webapps").stdout.split

    app_dir.each do |app|
      app << ".org.apache.juli.FileHandler.directory"
    end

    app_prefix.each do |app|
      app << ".org.apache.juli.FileHandler.prefix"
    end

    app_dir.each do |app|
        describe log_prop do
          its([app]) { should cmp "${catalina.base}/logs"}
        end
    end

    app_prefix.each do |app|
        describe log_prop do
          its([app]) { should cmp app.strip.split('.')[0] }
        end
    end
  end
end
