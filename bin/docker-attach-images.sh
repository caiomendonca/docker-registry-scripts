#!/bin/bash

helpFunction()
{
   echo ""
   echo "Version 1.0" 
   echo "Created by Caio Mendonca https://cmconsultor.com.br / https://github.com/caiomendonca" 
   echo "This script is a user-friendly interface to attach arm64 and amd64 docker images on same Docker Hub tag using /bin/manifest-tool" 
   echo "Example: $0 -u cmconsultor23 -r repository_name -t v1.0.0"
   echo -e "\t-u Docker hub registry name"
   echo -e "\t-r Docker hub repository name"
   echo -e "\t-t Image tag. Important: Images must be in the pattern, ex: registry/repository:tag-amd64 and registry/repository:tag-arm64"
   exit 1 # Exit script after printing help
}

while getopts "u:r:t:" opt
do
   case "$opt" in
      u ) parameterU="$OPTARG" ;;
      r ) parameterR="$OPTARG" ;;
      t ) parameterT="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterU" ] || [ -z "$parameterR" ] || [ -z "$parameterT" ]
then
   echo "Fill in all parameters!";
   helpFunction
fi

echo ""
echo "Version 1.0" 
echo "Created by Caio Mendonca https://cmconsultor.com.br / https://github.com/caiomendonca" 

DOCKER_CM_REGISTRY=$parameterU
DOCKER_CM_REPOSITORY=$parameterR
DOCKER_CM_TAG=$parameterT

echo -e "image: ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}\nmanifests:\n  -\n    image: ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-amd64\n    platform:\n      architecture: amd64\n      os: linux\n  -\n    image: ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-arm64\n    platform:\n      architecture: arm64\n      os: linux" > /tmp/manifest-tool-multiatch.yaml
sudo manifest-tool push from-spec /tmp/manifest-tool-multiatch.yaml

while true; do
    read -p "Do you want to push this multi-arch image in latest tag to? This will overwrite the current latest images (Y/N) " yn
    case $yn in
        [Yy]* ) echo -e "image: ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:latest\nmanifests:\n  -\n    image: ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-amd64\n    platform:\n      architecture: amd64\n      os: linux\n  -\n    image: ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-arm64\n    platform:\n      architecture: arm64\n      os: linux" > /tmp/manifest-tool-multiatch.yaml && sudo manifest-tool push from-spec /tmp/manifest-tool-multiatch.yaml; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

sudo rm /tmp/manifest-tool-multiatch.yaml
