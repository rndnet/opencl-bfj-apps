#!/bin/bash

. common

set -eou

if [ $# -eq 0 ]; then
  CM=podman
else
  CM=$1
fi

echo "Use $CM as container manager"

#VER=`date +"%Y-%m-%d_%H-%M-%S"`
REP=docker.io/rndnet/opencl-bfj-apps
VER=`date +"%Y-%m-%d"`

echo
echo "Build ....."
$CM build -t ${REP}:${TAG}-${VER} -t ${REP}:${TAG}  --no-cache -f Dockerfile

echo
echo Upload images
$CM login
$CM push ${REP}:${TAG}-${VER} 
$CM push ${REP}:${TAG}

