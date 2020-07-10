FROM docker.io/rndnet/opencl-bfj

ENV LIBRARY_PATH=/opt/amdgpu-pro/lib64
ENV PYTHONPATH=/ms

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y git gcc-c++ make opencl-headers ocl-icd cmake3 libconfig-devel \
                   boost-devel hdf5-devel pugixml-devel python3-devel eigen3-devel
RUN if [ -e ~/.ssh/id_rsa ]; then git clone --recursive --branch ipython git@gitlab.com:modernseismic/rnd/microseism.git microseism-src; else git clone --recursive --branch ipython https://gitlab.com/modernseismic/rnd/microseism.git microseism-src; fi
RUN cmake3 -DCMAKE_BUILD_TYPE=Release -DOpenCL_LIBRARY=/opt/amdgpu-pro/lib64/libOpenCL.so -Bmicroseism-build microseism-src
RUN cmake3 --build microseism-build
RUN mkdir -p /ms/microseism && \
    cp microseism-src/microseism/*.py microseism-build/microseism/micros_ext*.so /ms/microseism && \
    rm -r microseism-src microseism-build
RUN pip3 install lxml tqdm scipy ipython ipywidgets

