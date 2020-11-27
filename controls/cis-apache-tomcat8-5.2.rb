# frozen_string_literal: true

control 'cis-apache-tomcat8-5.2' do
  title '5.2 Use LockOut Realms (Scored)'
  desc  "A LockOut realm wraps around standard realms adding the ability to
lock a user out after multiple failed logins. Locking out a user after multiple
failed logins slows down attackers from brute forcing logins. "
  impact 0.5
  ref 'http://tomcat.apache.org/tomcat-8.0-doc/realm-howto.html'
  ref 'http://tomcat.apache.org/tomcat-8.0-doc/config/realm.html'
  tag "severity": 'medium'
  tag "cis_id": '5.2'
  tag "cis_control": ['No CIS Control', '6.1']
  tag "cis_level": 2
  desc 'check', "Perform the following to check to see if a LockOut realm
is being used:
# grep 'LockOutRealm' $CATALINA_HOME/conf/server.xml
"
  desc 'fix', "Create a lockout realm wrapping the main realm like the example
below:
<Realm className='org.apache.catalina.realm.LockOutRealm'
failureCount='3' lockOutTime='600' cacheSize='1000'
cacheRemovalWarningTime='3600'>
<Realm
className='org.apache.catalina.realm.DataSourceRealm'
dataSourceName=... />
</Realm>
"

  lockoutRealm = 'org.apache.catalina.realm.LockOutRealm'

  describe.one do
    describe xml("#{input('tomcat_home')}/conf/server.xml") do
      its('Server/Service/Engine/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/server.xml") do
      its('Server/Service/Engine/Realm/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/server.xml") do
      its('Server/Service/Host/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/server.xml") do
      its('Server/Service/Host/Realm/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/server.xml") do
      its('Server/Service/Context/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/server.xml") do
      its('Server/Service/Context/Realm/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/context.xml") do
      its('Context/Realm/@className') { should cmp lockoutRealm }
    end
    describe xml("#{input('tomcat_home')}/conf/context.xml") do
      its('Context/Realm/Realm/@className') { should cmp lockoutRealm }
    end
  end
end