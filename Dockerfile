FROM docker.io/nvidia/cuda:11.0-base

##ENV LIBRARY_PATH=/opt/amdgpu-pro/lib64
#ENV GPU_FORCE_64BIT_PTR=1
#ENV GPU_USE_SYNC_OBJECTS=1
#ENV GPU_MAX_ALLOC_PERCENT=100

ENV TZ=Europe/Moscow

#COPY files /opt
#RUN apt-get update && apt-get install xz-utils && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#RUN cd /opt/ && tar -xvf amdgpu-pro-20.20-1089974-ubuntu-20.04.tar.xz && cd amdgpu-pro-20.20-1089974-ubuntu-20.04 && ./amdgpu-install -y --opencl=legacy --headless --no-dkms 

RUN apt-get update && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y libnvidia-compute-450 opencl-headers clinfo git g++ make cmake python3 python3-pip libboost-all-dev libhdf5-serial-dev libpugixml-dev libconfig++-dev libopenmpi-dev

RUN pip3 install -r https://server1.rndnet.net/static/simple/bfj/requirements.txt && pip3 install --index-url https://server1.rndnet.net/static/simple bfj

RUN cd / &&  if [ -e ~/.ssh/id_rsa ]; then git clone --recursive git@gitlab.com:modernseismic/rnd/microseism.git; else git clone --recursive https://gitlab.com/modernseismic/rnd/microseism.git; fi

RUN CC=mpicc CXX=mpicxx cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-L/usr/lib/x86_64-linux-gnu/hdf5/serial/ -I/usr/include/hdf5/serial -DCL_TARGET_OPENCL_VERSION=120" -DOpenCL_LIBRARY=/lib/x86_64-linux-gnu/libOpenCL.so.1 -Bmicroseism-build microseism  && \
    cmake --build microseism-build -- microseism && \
    cp microseism-build/microseism /usr/local/bin && rm -r microseism microseism-build

COPY test /test
