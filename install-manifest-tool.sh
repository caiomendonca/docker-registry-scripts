#!/bin/bash

# set variables
MANIFEST_TOOL_VERSION="2.0.8"

# install dependencies
sudo apt install wget -y

# download manifest-tool
sudo wget -O /tmp/manifest-tool.tar.gz github.com/estesp/manifest-tool/releases/download/v${MANIFEST_TOOL_VERSION}/binaries-manifest-tool-${MANIFEST_TOOL_VERSION}.tar.gz
sudo mkdir -p /tmp/manifest-tool
sudo tar -xf /tmp/manifest-tool.tar.gz --directory /tmp/manifest-tool

# copy amd64 bin to /bin
sudo mv /tmp/manifest-tool/manifest-tool-linux-amd64 /bin/manifest-tool

# delete downloaded files
sudo rm -rf /tmp/manifest-tool.tar.gz /tmp/manifest-tool

# copy temmplates to /etc/manifest-tool
sudo mkdir -p /etc/manifest-tool
sudo cp -r $PWD/templates /etc/manifest-tool/