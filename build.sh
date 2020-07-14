#!/bin/bash
podman pull docker.io/rndnet/opencl-bfj
podman build -t docker.io/rndnet/opencl-bfj-apps:microseism1d -v ${HOME}/.ssh:/root/.ssh   --no-cache -f Dockerfile  #use git clone git: ... for microsesm library
#podman build -t docker.io/rndnet/opencl-bfj-apps:microseism1d                             --no-cache -f Dockerfile  #use git clone https: ... for microsesm library
