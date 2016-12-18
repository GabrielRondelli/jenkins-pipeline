
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

describe "MySQL server checks for #{ENV['TARGET_HOST']}" do


 # describe package('mysql') do
 #   it { should be_installed }
 # end

 # describe process("mysql") do
 #   it { should be_running }
 # end

  describe command('mysql -V') do

    # test '5.6.34' exists before "Distrib".
    its(:stdout) { should contain('5.6.34').after('Distrib') }
  end


end

