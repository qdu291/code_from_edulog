#!/bin/bash -xe
filename=$1
fe_version=$2
be_env=$3

# Update Protocol
jq ".protocol = \"https://\"" /tmp/${filename}.${be_env}.json  | sponge /tmp/${filename}.${be_env}.json
# Update Websocket Path
jq ".smqPath = \"/ws\"" /tmp/${filename}.${be_env}.json  | sponge /tmp/${filename}.${be_env}.json
# Update BE URL
jq ".baseUrl = \"ath-be-${be_env}.karrostech.net\"" /tmp/${filename}.${be_env}.json  | sponge /tmp/${filename}.${be_env}.json
# Update FE version
jq ".version = \"${fe_version}\"" /tmp/${filename}.${be_env}.json  | sponge /tmp/${filename}.${be_env}.json