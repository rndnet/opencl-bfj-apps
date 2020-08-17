#!/bin/bash

#VER=`date +"%Y-%m-%d_%H-%M-%S"`
TAG=nvidia-11.0-microseism1d
REP=docker.io/rndnet/opencl-bfj-apps
VER=`date +"%Y-%m-%d"`

echo
echo "Build ....."
#podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG} -v ${HOME}/.ssh:/root/.ssh  -f Dockerfile  #use git clone git: ... for microsesm library
podman build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG} -v ${HOME}/.ssh:/root/.ssh  --no-cache -f Dockerfile  #use git clone git: ... for microsesm library

echo
echo Upload images
podman login docker.io
podman push ${REP}:${TAG}-${VER} 
podman push ${REP}:${TAG}

