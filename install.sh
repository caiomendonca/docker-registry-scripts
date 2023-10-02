#!/bin/bash

echo ""
echo "Version 1.0" 
echo "Created by Caio Mendonca https://cmconsultor.com.br / https://github.com/caiomendonca"

# set variables
OS_ARCH=$(arch)
MANIFEST_TOOL_VERSION="2.0.8"
# ainda nao testado
if [ $OS_ARCH == "x86_64" ]; then
    # install dependencies
    echo "installing depencencies.."
    sudo apt install wget tar qemu-user-static binfmt-support -y

    # install qemu
    echo "configure qemu.."
    sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

    # backup manifest-tool
    echo "backuping manisfest-tool to ${HOME}.."
    sudo mv /bin/manifest-tool $HOME/manifest-tool-$(date -u +"%FT%H%MZ")

    # download manifest-tool
    echo "downloading manifest-tool $MANIFEST_TOOL_VERSION}.."
    sudo wget -O /tmp/manifest-tool.tar.gz github.com/estesp/manifest-tool/releases/download/v${MANIFEST_TOOL_VERSION}/binaries-manifest-tool-${MANIFEST_TOOL_VERSION}.tar.gz
    sudo mkdir -p /tmp/manifest-tool
    sudo tar -xf /tmp/manifest-tool.tar.gz --directory /tmp/manifest-tool

    # copy amd64 bin to /bin
    echo "installing manifest-tool.."
    sudo mv /tmp/manifest-tool/manifest-tool-linux-amd64 /bin/manifest-tool

    # delete downloaded files
    echo "deleting downloaded files.."
    sudo rm -rf /tmp/manifest-tool.tar.gz /tmp/manifest-tool

    # copy scripts to /bin
    echo "installing scripts.."
    sudo cp -r $PWD/docker-create-image.sh /bin/docker-create-image && sudo chmod +x /bin/docker-create-image
    sudo cp -r $PWD/docker-push-image.sh /bin/docker-push-image && sudo chmod +x /bin/docker-push-image
    sudo cp -r $PWD/docker-attach-images.sh /bin/docker-attach-images && sudo chmod +x /bin/docker-attach-images
    
else
    "This script is only compatible with x86_64 operating systems"
fi