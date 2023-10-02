#!/bin/bash

helpFunction()
{
   echo ""
   echo "Version 1.0" 
   echo "Created by Caio Mendonca https://cmconsultor.com.br / https://github.com/caiomendonca"
   echo "Example: $0 -u cmconsultor23 -r repository_name -t v1.0.0 -a both "
   echo "Warning: Don't forget to login in Docker Hub before running this script with "docker login -u yourDockerhubUser -pYourPassword" command"
   echo -e "\t-u Docker hub registry name"
   echo -e "\t-r Docker hub repository name"
   echo -e "\t-t Image tag"
   echo -e "\t-a Image architeture (avalilable: arm64, amd64 or both. - "both" will send amd64 and arm64 to docker registry)"
   exit 1 # Exit script after printing help
}

while getopts "u:r:t:a:" opt
do
   case "$opt" in
      u ) parameterU="$OPTARG" ;;
      r ) parameterR="$OPTARG" ;;
      t ) parameterT="$OPTARG" ;;
      a ) parameterA="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterU" ] || [ -z "$parameterR" ] || [ -z "$parameterT" ] || [ -z "$parameterA" ]
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

if [ ${DOCKER_CM_ARCH} == "amd64" ] || [ ${DOCKER_CM_ARCH} == "arm64" ]; then
    sudo docker push ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-${DOCKER_CM_ARCH}
elif [ ${DOCKER_CM_ARCH} == "both" ]; then
    sudo docker push ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-arm64
    sudo docker push ${DOCKER_CM_REGISTRY}/${DOCKER_CM_REPOSITORY}:${DOCKER_CM_TAG}-amd64
else
    echo "Invalid architeture. "
    echo "Valid values: "arm64" "amd64" "both"."
fi