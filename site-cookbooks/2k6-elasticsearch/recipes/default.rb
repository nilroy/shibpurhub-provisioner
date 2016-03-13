#
# Cookbook Name:: 2k6-elasticsearch
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

node.set[:java][:jdk_version]							  = 8
node.set[:java][:install_flavor]						= "oracle"
node.set[:java][:oracle][:accept_oracle_download_terms]	= true

include_recipe "java"

include_recipe 'sysctl::default'

sysctl_param 'vm.max_map_count' do
      value 262144
end

include_recipe "elasticsearch::default"
elasticsearch_configure 'elasticsearch' do
    configuration ({
      'network.host' => '0.0.0.0'
    })
    notifies :restart, "service[elasticsearch]", :delayed
end
elasticsearch_service 'elasticsearch' do
  notifies :restart, "service[elasticsearch]", :delayed
end

elasticsearch_plugin 'kopf' do
  url 'lmenezes/elasticsearch-kopf'
end

service "elasticsearch" do
  supports :restart, :enable
  action :nothing
end
