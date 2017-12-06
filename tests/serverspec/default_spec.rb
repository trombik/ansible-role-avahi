require "spec_helper"
require "serverspec"

package = "avahi"
service = "avahi"
config  = "/etc/avahi/avahi-daemon.conf"
user    = "avahi"
group   = "avahi"
ports   = []
default_user = "root"
default_group = "root"

case os[:family]
when "freebsd"
  package = "avahi-app"
  config = "/usr/local/etc/avahi/avahi-daemon.conf"
  default_group = "wheel"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match(/^\[server\]\nhost-name=foo\ndomain-name=example\.org\nbrowse-domains=example\.org\nuse-ipv6=no\nratelimit-interval-usec=1000000\nratelimit-burst=1000$/) }
  its(:content) { should match(/^\[wide-area\]\nenable-wide-area=yes$/) }
  its(:content) { should match(/^\[publish\]$/) }
  its(:content) { should match(/^\[reflector\]$/) }
  its(:content) { should match(/^\[rlimits\]\nrlimit-core=0\nrlimit-data=4194304\nrlimit-fsize=0\nrlimit-nofile=768\nrlimit-stack=4194304\nrlimit-nproc=3$/) }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/avahi") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/^avahi_daemon_flags="-D"$/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
