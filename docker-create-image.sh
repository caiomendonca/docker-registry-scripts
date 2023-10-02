#!/bin/bash

helpFunction()
{
   echo ""
   echo "Version 1.0" 
   echo "Created by Caio Mendonca https://cmconsultor.com.br / https://github.com/caiomendonca" 
   echo "This script is a user-friendly interface to create docker images on amd64/amm64 architectures using qemu for arm64 emulate" 
   echo "Example: $0 -u cmconsultor23 -r repository_name -t v1.0.0 -a amd64 -d /path/to/Dockerfile -l /path/to/files/to/make/image"
   echo -e "\t-u Docker hub registry name"
   echo -e "\t-r Docker hub repository name"
   echo -e "\t-t Image tag"
   echo -e "\t-a Image architeture (avalilable: arm64 or amd64)"
   echo -e "\t-d Dockerfile location - can use ./Dockerfile to use Dockerfile in current dir"
   echo -e "\t-l Docker image files location - can use . to use current dir"
   exit 1 # Exit script after printing help
}

while getopts "u:r:t:a:d:l:" opt
do
   case "$opt" in
      u ) parameterU="$OPTARG" ;;
      r ) parameterR="$OPTARG" ;;
      t ) parameterT="$OPTARG" ;;
      a ) parameterA="$OPTARG" ;;
      d ) parameterD="$OPTARG" ;;
      l ) parameterL="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterU" ] || [ -z "$parameterR" ] || [ -z "$parameterT" ] || [ -z "$parameterA" ] || [ -z "$parameterD" ] || [ -z "$parameterL" ]
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
DOCKER_CM_ARCH=$parameterA
DOCKER_CM_DOCKERFILE=$parameterD
DOCKER_CM_DIR_EXEC=$parameterL

if [ $DOCKER_CM_ARCH == "amd64" ] || [ $DOCKER_CM_ARCH == "arm64" ]; then
    if [ $DOCKER_CM_ARCH == "amd64" ]; then
        echo "Arch is amd64";
        sudo docker build -t ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-${DOCKER_CM_ARCH} -f ${DOCKER_CM_DOCKERFILE} ${DOCKER_CM_DIR_EXEC}
    else
        echo "Arch is arm64";
        sudo docker buildx build --platform linux/${DOCKER_CM_ARCH} -t ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-${DOCKER_CM_ARCH} -f ${DOCKER_CM_DOCKERFILE} ${DOCKER_CM_DIR_EXEC}
    fi  
else
    echo "Please, put a valid architeture (amd64 or arm64)";
fi