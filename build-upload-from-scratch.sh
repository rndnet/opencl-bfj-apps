#!/bin/bash

set -eou

AMD_DRV=amdgpu-pro-20.20-1089974-rhel-7.8.tar.xz
DF=Dockerfile-scratch
#VER=`date +"%Y-%m-%d_%H-%M-%S"`
TAG=microseism1d
REP=docker.io/rndnet/opencl-bfj-apps
VER=`date +"%Y-%m-%d"`

mkdir -p build/files

if [ ! -f build/files/${AMD_DRV} ]; then
    echo
    echo "Download AMD drivers: ${AMD_DRV}"
    referer="https://www.amd.com/en/support/kb/release-notes/rn-rad-lin-20-20-unified" 
    download="https://drivers.amd.com/drivers/linux/${AMD_DRV}"
    wget ${download} --referer ${referer}  -O build/files/${AMD_DRV}
fi 

cd build

echo
echo "Remove FROM command from origin Dockerfile"
sed '/^FROM /d' ../Dockerfile > Dockerfile_origin
echo
echo "Get base image Dockerfile"
wget https://raw.githubusercontent.com/rndnet/opencl-bfj/master/Dockerfile -O $DF   
echo
echo "Create new Dockerfile: append two Dockerfiles"
cat Dockerfile_origin  >> $DF
cat $DF

echo
echo "Build ....."
podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG} -v ${HOME}/.ssh:/root/.ssh --no-cache -f $DF  #use git clone git: ... for microsesm library
#podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG}                            --no-cache -f $DF  #use git clone https: ... for microsesm library

rm -rv $DF Dockerfile_origin

echo
echo Upload images
podman login docker.io
podman push ${REP}:${TAG}-${VER} 
podman push ${REP}:${TAG}

