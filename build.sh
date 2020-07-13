#!/bin/bash
podman build -t docker.io/rndnet/opencl-bfj-apps:ms1d-cpu -v ${HOME}/.ssh:/root/.ssh -f Dockerfile  #use git clone git: ... for microsesm library
#podman build -t docker.io/rndnet/opencl-bfj-apps:ms1d-cpud                             --no-cache -f Dockerfile  #use git clone https: ... for microsesm library
