#!/bin/bash
. common
podman login docker.io
podman push docker.io/rndnet/opencl-bfj-apps:${TAG}
