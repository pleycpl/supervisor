#
# Cookbook Name:: supervisor
# Recipe:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

python_runtime '2' do
  version '2.7'
  options :system
end

python_package 'supervisor'

directory node['supervisor']['dir'] do
  owner "root"
  group "root"
  mode "755"
  recursive true
end

directory node['supervisor']['supervisord']['log_dir'] do
  owner "root"
  group "root"
  mode "755"
  recursive true
end

template node['supervisor']['conf_file'] do
  source "supervisord.conf.erb"
  owner "root"
  group "root"
  mode "644"
  variables({
    :inet_port => node['supervisor']['inet_http_server']['inet_port'],
    :inet_username => node['supervisor']['inet_http_server']['inet_username'],
    :inet_password => node['supervisor']['inet_http_server']['inet_password'],
    :supervisord_minfds => node['supervisor']['supervisord']['minfds'],
    :supervisord_minprocs => node['supervisor']['supervisord']['minprocs'],
    :supervisord_nocleanup => node['supervisor']['supervisord']['nocleanup'],
    :socket_file => node['supervisor']['socket_file'],
  })
end

template "/etc/default/supervisor" do
  source "debian/supervisor.default.erb"
  owner "root"
  group "root"
  mode "644"
  only_if { platform_family?("debian") }
end

init_template_dir = value_for_platform_family(
  ["rhel", "fedora", "centos", "amazon"] => "rhel",
  "debian" => "debian"
)

case node['platform']
when "amazon", "centos", "debian", "fedora", "redhat", "ubuntu", "raspbian"
  template "/etc/init.d/supervisor" do
    source "#{init_template_dir}/supervisor.init.erb"
    owner "root"
    group "root"
    mode "755"
    variables({
      # TODO: use this variable in the debian platform-family template
      # instead of altering the PATH and calling "which supervisord".
      :supervisord => "/usr/local/bin/supervisord"
    })
  end

  service "supervisor" do
    supports :status => true, :restart => true
    action [:enable, :start]
  end
end
