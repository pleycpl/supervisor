#
# Cookbook Name:: supervisor
# Attribute File:: default
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
#

default['supervisor'] = {
  'dir': '/etc/supervisor.d',
  'conf_file': '/etc/supervisord.conf',
  'socket_file': '/var/run/supervisor.sock',
  'unix_http_server': {
    'chmod': '700',
    'chown': 'root:root',
  },
  'supervisord': {
    'log_dir': '/var/log/supervisor',
    'logfile_maxbytes': '50MB',
    'logfile_backups': 10,
    'loglevel': 'info',
    'pid_file': '/var/run/supervisord.pid',
    'minfds': 1024,
    'minprocs': 200,
    'nocleanup': false,
  },
  'inet_http_server': {
    'inet_port': '0.0.0.0:9001',
    'inet_username': nil,
    'inet_password': nil,
  },
  'ctlplugins': {},
}
