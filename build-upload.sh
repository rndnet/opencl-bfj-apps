#!/bin/bash

set -eou

#VER=`date +"%Y-%m-%d_%H-%M-%S"`
TAG=microseism3d
REP=docker.io/rndnet/opencl-bfj-apps
VER=`date +"%Y-%m-%d"`

echo
echo "Download last openc-bfj"
podman pull docker.io/rndnet/opencl-bfj

echo
echo "Build ....."
podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG} -v ${HOME}/.ssh:/root/.ssh --no-cache -f $DF  #use git clone git: ... for microsesm library
#podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG}                            --no-cache -f $DF  #use git clone https: ... for microsesm library

echo
echo Upload images
podman login docker.io
podman push ${REP}:${TAG}-${VER} 
podman push ${REP}:${TAG}

