#!/bin/bash
. common
podman build -t docker.io/rndnet/opencl-bfj-apps:${TAG} -v ${HOME}/.ssh:/root/.ssh -f Dockerfile  #use git clone git: ... for microsesm library
#podman build -t docker.io/rndnet/opencl-bfj-apps:${TAG}                             --no-cache -f Dockerfile  #use git clone https: ... for microsesm library
