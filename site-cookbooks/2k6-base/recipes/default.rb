#
# Cookbook Name:: 2k6-base
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


include_recipe 'chef-solo-search'
include_recipe 'apt'
include_recipe 'ntp'

# Upgrade ntp
%w(ntp ntpdate vim parallel).each do |pkg|
  package pkg do
    action :install
  end
end

python_pip "pip" do
  action :upgrade
end

#Install ruby 2.2.x
package "software-properties-common"

apt_repository "ruby2.2" do
  uri 'ppa:brightbox/ruby-ng'
  components ['main']
  distribution 'trusty'
  action :add
end

%w{ruby2.2 ruby2.2-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "bundler"
