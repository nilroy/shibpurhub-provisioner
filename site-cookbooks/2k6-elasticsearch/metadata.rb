name             "2k6-elasticsearch"
maintainer       "Nilanjan Roy"
maintainer_email "nilu.besu@gmail.com"
license          "Apache 2.0"
description      "Setup 2k6 elasticsearch server"
version          "0.0.1"

recipe "2k6-mongodb", "Setup 2k6 elasticsearch server"

depends "elasticsearch"
depends "java"
depends "sysctl"
