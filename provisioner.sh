#!/bin/bash
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

function initialize() {
  sudo apt-get -y clean && sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade

  sudo apt-get install -y git curl wget vim nano python-pip ruby bundler \
  zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev \
  libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev software-properties-common libffi-dev

  sudo pip install --upgrade pip
  mkdir -m 755 /tmp/chef-solo
  curl  https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.2.1-1_amd64.deb -o /tmp/chef-solo/chef_12.2.1-1_amd64.deb
  sudo dpkg --install /tmp/chef-solo/chef_12.2.1-1_amd64.deb
  bundle install
  librarian-chef install --verbose
}

function main() {
  echo "Initial installation begins...."
  initialize
  echo "Provisioning $name ...."
  tar -czvf /tmp/chef-solo/chef-solo.tar.gz cookbooks roles data_bags environments
  cp -Rv dna /tmp/chef-solo
  cd /tmp/chef-solo
  sudo /usr/bin/chef-solo -E $environment -j ./dna/${role}.json -r chef-solo.tar.gz -N $name && rm -rf /tmp/chef-solo
}


function show_options() {
echo ""
echo "USAGE: $SCRIPT_NAME [options] <args> [<arg>....] "
echo "Options:"
echo "     -h                            -- Show the usage of this script"
echo "     -x                            -- Enable tracing"
echo "     --env                         -- Chef Environment ,staging/prod"
echo "     --role                        -- Chef role"
echo "     --name                        -- Node name"
echo ""

exit $1

}

function arg_test() {
  if [ -z "$environment" ] ; then
    echo "Give Environment --env"
    exit 1
  fi

  if [ -z "$role" ] ; then
    echo "Give Role --role"
    exit 1
  fi

  if [ -z "$name" ] ; then
    echo "Name not provided. Using hostname"
    name=$(hostname)
  fi
}

SCRIPT_NAME=$(basename $0)
SCRIPT_HOME=$(dirname $0)
exec 2>&1

TEMP=$(getopt -o h,x, --long role:,env:,name: -n $SCRIPT_NAME -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"

if [ "$#" -lt 2 ]
then
  echo "All arguments are not passed!!" && show_options 1
fi

while :
do
		case $1 in
			          -x) set -x ; shift;;
								-h) show_options 0 ;;
             --env) environment=$2 ; shift 2;;
			      --role) role=$2 ; shift 2;;
            --name) name=$2 ; shift 2;;
					      --) shift ; break ;;
					       *) echo "Internal error!" ; show_options 1 ; exit 1;;
		esac
done

arg_test
main
