FROM node:14-bullseye

ADD install.sh /
RUN sh /install.sh

RUN echo "## Update and install packages" \
&&  apt-get -qq -y update && apt-get -qq install -y --no-install-recommends \
				bubblewrap \
        wget \
        git-core \
        ca-certificates \
        build-essential \
        file \
&&  echo "## Done"

RUN opam init -y

ENV EMSDK /emsdk_portable
ENV EM_DATA ${EMSDK}/.data
ENV EM_CONFIG ${EMSDK}/.emscripten
ENV EM_CACHE ${EM_DATA}/cache
ENV EM_PORTS ${EM_DATA}/ports

ADD emsdk-2.0.34.zip .
RUN	echo "## Installing CMake" \
    &&	wget https://cmake.org/files/v3.18/cmake-3.18.3-Linux-x86_64.sh -q \
    &&	mkdir /opt/cmake \
    &&	printf "y\nn\n" | sh cmake-3.18.3-Linux-x86_64.sh --prefix=/opt/cmake > /dev/null \
    &&		rm -fr cmake*.sh /opt/cmake/doc \
    &&		rm -fr /opt/cmake/bin/cmake-gui \
    &&		rm -fr /opt/cmake/bin/ccmake \
    &&		rm -fr /opt/cmake/bin/cpack \
    &&	ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
    &&	ln -s /opt/cmake/bin/ctest /usr/local/bin/ctest

RUN  echo "## Get EMSDK" \
    &&  unzip emsdk-2.0.34.zip \
    &&  mv emsdk-2.0.34 emsdk \
		&&  cd emsdk \
		&&  ./emsdk install 2.0.34 \
		&&  ./emsdk activate 2.0.34 \
&&  echo "## Done"

ENV PATH="/emsdk/upstream/emscripten:${PATH}"
ENV EMSDK="/Users/duzhongchen/Workspace/emsdk"
