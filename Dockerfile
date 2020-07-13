FROM amd64/ubuntu:18.04
ARG GIT_COMMIT=master
ARG GH_PR
ARG GH_SLUG=pocl/pocl
ARG LLVM_VERSION=6.0
LABEL git-commit=$GIT_COMMIT vendor=pocl distro=Ubuntu version=1.0
ENV TERM dumb
RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common wget
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-${LLVM_VERSION} main" && apt update
RUN apt install -y build-essential ocl-icd-libopencl1 cmake git pkg-config libclang-${LLVM_VERSION}-dev clang-${LLVM_VERSION} llvm-${LLVM_VERSION} make ninja-build ocl-icd-libopencl1 ocl-icd-dev ocl-icd-opencl-dev libhwloc-dev zlib1g zlib1g-dev clinfo dialog apt-utils

RUN cd /home ; git clone https://github.com/$GH_SLUG.git ; cd /home/pocl ; git checkout $GIT_COMMIT
RUN cd /home/pocl ; test -z "$GH_PR" || (git fetch origin +refs/pull/$GH_PR/merge && git checkout -qf FETCH_HEAD) && :
RUN cd /home/pocl ; mkdir b ; cd b; cmake -G Ninja -DWITH_LLVM_CONFIG=/usr/bin/llvm-config-${LLVM_VERSION} -DCMAKE_INSTALL_PREFIX=/usr ..
RUN cd /home/pocl/b ; ninja install
CMD cd /home/pocl/b ; clinfo ; ctest -j4 --output-on-failure -L internal

ENV PYTHONPATH=/ms

RUN apt-get install -y cmake libboost-all-dev libconfig-dev libhdf5-dev libpugixml-dev python3-dev libeigen3-dev python3-pip
RUN if [ -e ~/.ssh/id_rsa ]; then git clone --recursive --branch ipython git@gitlab.com:modernseismic/rnd/microseism.git microseism-src; else git clone --recursive --branch ipython https://gitlab.com/modernseismic/rnd/microseism.git microseism-src; fi
RUN mkdir microseism-build && cd microseism-build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-std=gnu++11 -fext-numeric-literals" ../microseism-src
RUN cmake --build microseism-build
RUN mkdir -p /ms/microseism && \
    cp microseism-src/microseism/*.py microseism-build/microseism/micros_ext*.so /ms/microseism && \
    rm -r microseism-src microseism-build
RUN pip3 install lxml tqdm scipy ipython ipywidgets
RUN pip3 install -r https://server1.rndnet.net/static/simple/bfj/requirements.txt && pip3 install --index-url https://server1.rndnet.net/static/simple bfj
