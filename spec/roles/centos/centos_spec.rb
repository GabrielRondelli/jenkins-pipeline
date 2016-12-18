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


packages = [
  'libselinux-python',
  'mlocate',
  'vim-minimal',
  'mailx',
  'ntp',
  'git',
  'wget',
  'ferm']

  describe "CentOS Operating System Checks for #{ENV['TARGET_HOST']}" do

    packages.each do|p|
      describe package(p) do
        it { should be_installed }
      end
    end

    describe "Core services should be running" do
      describe service('sshd') do
        it { should be_enabled   }
        it { should be_running   }
      end

      describe port(22) do
        it { should be_listening }
      end

#      describe service('iptables') do
#        it { should be_disabled   }
#        it { should be_running   }
#      end

      describe service('postfix') do
        it { should be_enabled   }
        it { should be_running   }
      end
    end

    describe "The network should be configured properly" do

      describe command("ifconfig enp0s3") do
        its(:stdout) {should include '08:00:27:0b:bc:9d' }
      end

      describe interface("enp0s3") do
        #its(:speed) { should eq 1000 }
        it { should have_ipv4_address("10.0.2.6/24") }
      end

      describe host( ENV['TARGET_HOST'] ) do
        it { should be_reachable }
      end

      describe command('hostname') do
        its(:stdout) { should include "slave01" }
      end

      describe default_gateway do
        its(:ipaddress) { should eq "10.0.2.1" }
      end

      describe command('cat /etc/resolv.conf') do
        its(:stdout) {should include '8.8.8.8'}
      end

    end #Network
end
