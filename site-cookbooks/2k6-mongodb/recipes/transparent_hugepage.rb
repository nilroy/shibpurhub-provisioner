#
# Cookbook Name:: 2k6-mongodb
# Recipe:: transparent_hugepage
#
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

template "/etc/init.d/disable-transparent-hugepages" do
  source "disable-transparent-hugepages.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :transparent_hugepage_enabled => "never",
    :transparent_hugepage_defrag => "never"
  )
  notifies :start, "service[disable-transparent-hugepages]", :immediately
  notifies :restart, "service[mongod]", :delayed
end

service "disable-transparent-hugepages" do
  supports :start => true, :enable => true
  action :enable
end

service "mongod" do
  supports :restart => true
  action :nothing
end
