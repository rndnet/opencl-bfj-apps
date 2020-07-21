#!/bin/bash
. common
podman run --rm -it --device=/dev/dri:/dev/dri docker.io/rndnet/opencl-bfj-apps:${TAG}  bash 
