FROM docker.io/nvidia/cuda:11.0-base

ENV PYTHONPATH=/ms

RUN apt-get update && apt-get install -y clinfo libnvidia-compute-450 git g++ make cmake python3 python3-pip libboost-all-dev libhdf5-serial-dev libpugixml-dev libeigen3-dev libpython3-dev libconfig++-dev opencl-headers

RUN pip3 install -r https://server1.rndnet.net/static/simple/bfj/requirements.txt && pip3 install --index-url https://server1.rndnet.net/static/simple bfj

RUN pip3 install lxml tqdm scipy ipython ipywidgets

RUN if [ -e ~/.ssh/id_rsa ]; then git clone --recursive --branch ipython git@gitlab.com:modernseismic/rnd/microseism.git microseism-src; else git clone --recursive --branch ipython https://gitlab.com/modernseismic/rnd/microseism.git microseism-src; fi

RUN cmake -DCMAKE_BUILD_TYPE=Release   -DOpenCL_LIBRARY=/lib/x86_64-linux-gnu/libOpenCL.so.1 -Bmicroseism-build microseism-src && \
    cmake --build microseism-build && \
    mkdir -p /ms/microseism && \
    cp microseism-src/microseism/*.py microseism-build/microseism/micros_ext*.so /ms/microseism && \
    rm -r microseism-src microseism-build
