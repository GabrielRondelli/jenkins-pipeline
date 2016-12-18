
require 'serverspec'
require 'net/ssh'
require 'highline/import'


#set :env, :SUDO_PASSWORD => 'reverse'
set :env, :TARGET_HOST => '10.0.2.6'

set :backend, :ssh
set :disable_sudo, true

#set :sudo_password, ENV['SUDO_PASSWORD']

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user]='root'
options[:password]='reverse'

set :host, host
set :ssh_options, options

describe "HTTP checks for #{ENV['TARGET_HOST']}" do
  
  describe package('httpd') do
    it { should be_installed }
  end

  describe process("httpd") do
    it { should be_running }
  end

  describe command('apachectl -V') do
    # test 'Prefork' exists between "Server MPM" and "Server compiled".
    #its(:stdout) { should contain('Prefork').from(/^Server MPM/).to(/^Server compiled/) }

    # test 'conf/httpd.conf' exists after "SERVER_CONFIG_FILE".
    its(:stdout) { should contain('conf/httpd.conf').after('SERVER_CONFIG_FILE') }

    # test 'Apache/2.4.6' exists before "Server built".
    its(:stdout) { should contain(' Apache/2.4.6').before('Server built') }
  end
end
