FROM docker.io/rndnet/opencl-bfj

ENV LIBRARY_PATH=/opt/amdgpu-pro/lib64

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y git gcc-c++ make opencl-headers ocl-icd cmake3 libconfig-devel \
                   boost-devel openmpi-devel hdf5-devel pugixml-devel
RUN git clone --recursive https://gitlab.com/modernseismic/rnd/microseism.git
RUN source /usr/share/Modules/init/sh && module load mpi && \
    CC=mpicc CXX=mpicxx cmake3 -DCMAKE_BUILD_TYPE=Release -DOpenCL_LIBRARY=/opt/amdgpu-pro/lib64/libOpenCL.so -Bmicroseism-build microseism
RUN cmake3 --build microseism-build -- microseism
RUN cp microseism-build/microseism /usr/local/bin && rm -r microseism microseism-build
