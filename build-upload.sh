#!/bin/bash

set -eou

#VER=`date +"%Y-%m-%d_%H-%M-%S"`
TAG=nvidia-11.0-microseism3d
REP=docker.io/rndnet/opencl-bfj-apps
VER=`date +"%Y-%m-%d"`

#AMD_DRV=amdgpu-pro-20.20-1089974-ubuntu-20.04.tar.xz
#mkdir -p files
#if [ ! -f files/${AMD_DRV} ]; then
#    echo
#    echo "Download AMD drivers: ${AMD_DRV}"
#    referer="https://www.amd.com/en/support/kb/release-notes/rn-rad-lin-20-20-unified"
#    download="https://drivers.amd.com/drivers/linux/${AMD_DRV}"
#    wget ${download} --referer ${referer}  -O files/${AMD_DRV}
#fi

echo
echo "Build ....."
#podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG} -v ${HOME}/.ssh:/root/.ssh  -f Dockerfile  #use git clone git: ... for microsesm library
podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG} -v ${HOME}/.ssh:/root/.ssh  --no-cache -f Dockerfile  #use git clone git: ... for microsesm library

echo
echo Upload images
podman login docker.io
podman push ${REP}:${TAG}-${VER} 
podman push ${REP}:${TAG}
