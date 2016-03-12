#!/bin/bash

function initialize() {
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y git curl wget vim nano python-pip
  sudo pip install --upgrade pip
  curl -O https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.2.1-1_amd64.deb
  sudo dpkg --install chef_12.2.1-1_amd64.deb
  bundle install
  librarian-chef install --verbose
}

function main() {
  echo "Initial installation begins...."
  initialize
  tar -czvf chef-solo.tar.gz cookbooks roles data_bags environments
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
    echo "Give Name --name"
    exit 1
  fi
}

SCRIPT_NAME=$(basename $0)
SCRIPT_HOME=$(dirname $0)
exec 2>&1

TEMP=$(getopt -o h,x, --long role:,env:,name: -n $SCRIPT_NAME -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"

if [ "$#" -lt 3 ]
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
