name             "2k6-mongodb"
maintainer       "Nilanjan Roy"
maintainer_email "nilu.besu@gmail.com"
license          "Apache 2.0"
description      "Setup 2k6 mongodb server"
version          "0.0.1"

recipe "2k6-mongodb", "Setup 2k6 mongodb server"

depends "2k6-base"
depends "mongodb"
depends "mongodb-agents"
