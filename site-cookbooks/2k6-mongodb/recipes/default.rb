#
# Cookbook Name:: 2k6-mongodb
# Recipe:: default
#
# Copyright:: 2016, Nilanjan Roy (<nilu.besu@gmail.com>)
# Authors:
#       Nilanjan Roy <nilu.besu@gmail.com>
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
node.set['2k6']['mongodb']['port'] = 27017
node.set['mongodb']['config']['replSet']            = '2k6'
node.set['mongodb']['cluster_name']                 = '2k6'
node.set['mongodb']['auto_configure']['replicaset'] = false
node.set['mongodb']['auto_configure']['sharding']   = false

node.set['mongodb']['dbconfig_file']            = '/etc/mongod.conf'
node.set['mongodb']['config']['logpath']        = '/var/log/mongodb/mongod.log'
node.set['mongodb']['sysconfig_file']           = '/etc/default/mongod'
node.set['mongodb']['default_init_name']        = 'mongod'
node.set['mongodb']['instance_name']            = 'mongod'
node.set['mongodb']['sysconfig']['DAEMON_OPTS'] = "--config #{node['mongodb']['dbconfig_file']}"
node.set['mongodb']['sysconfig']['CONFIGFILE']  = node['mongodb']['dbconfig_file']

# Disable TTL monitor as it will kill the performance
node.set['mongodb']['config']['setParameter'] = 'ttlMonitorEnabled=false'
node.set['mongodb']['config']['auth'] = true

# Set nssize
case node.chef_environment
when 'prod'
  node.set['mongodb']['config']['nssize'] = 768
when 'staging'
  node.set['mongodb']['config']['nssize'] = 32
end


include_recipe 'mongodb::mongodb_org_30_repo'
include_recipe 'mongodb::replicaset'


r = chef_gem "mongo" do
  action :nothing
end
r.run_action(:install)

q = gem_package "mongo" do
  action :nothing
end
q.run_action(:install)

include_recipe 'mongodb::user_management'

mongodb_instance "mongodb" do
  port node['2k6']['mongodb']['port']
end

# Delete default data directories if they are not used
%w{/var/lib/mongodb /var/lib/mongo}.each do |d|
  directory d do
    action :delete
    recursive true
    not_if { node['mongodb']['config']['dbpath'] == d }
  end
end

# Set kernel clocksource to tsc
execute "set-clocksource-tsc" do
  command 'echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource'
  action :run
  retries 3
  retry_delay 10
end

include_recipe '2k6-mongodb::transparent_hugepage'
