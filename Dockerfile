FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# set noninteractive installation
ENV DEBIAN_FRONTEND noninteractive

# install prerequirements
RUN apt-get update
RUN apt-get install -y sudo \
	build-essential \
	libgflags-dev \
	python-scipy \
	curl \
	liblmdb-dev \
	python-skimage \
	python-skimage-lib \
	git \
	hdf5-tools \
	make \
	automake \
	libprotobuf-dev \
	g++ \
	libsnappy-dev \
	python-dev \
	python-gflags \
	libgoogle-glog-dev \
	python-opencv \
	unzip \
	python-protobuf \
	libopencv-dev \
	libtool \
	wget \
	libhdf5-dev \
	autoconf \
	libboost-all-dev \
	python-pip \
	libleveldb-dev \
	protobuf-compiler \
	libatlas-base-dev

# set your timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata

# build and get caffe and toolbox
RUN cd /opt && \
	git clone https://github.com/arikpoz/deep-visualization-toolbox.git && \
	cd deep-visualization-toolbox && \
	rm -r caffe && \
	git clone https://github.com/BVLC/caffe && \
	cd caffe && \
	git remote add arikpoz https://github.com/arikpoz/caffe && \
	git fetch --all && \
	git checkout --track -b deconv-deep-vis-toolbox arikpoz/master && \
	git config --global user.email "you@example.com" && \
	git config --global user.name "Your Name" && \
	git merge master

# copy prepared Makefile.config to caffe directory of container
COPY ./Makefile.config /opt/deep-visualization-toolbox/caffe/Makefile.config

# compile caffe
RUN cd /opt/deep-visualization-toolbox/caffe/ && \
	make all && \
	make pycaffe

# Replace 1000 with your user / group id
ENV HOME=/home/developer \
	CAFFE_ROOT=/opt/deep-visualization-toolbox/caffe \
	DVTB_ROOT=/opt/deep-visualization-toolbox \
	uid=1000 gid=1000

RUN groupadd -g $gid developer && \
    useradd -N -m -d $HOME -u $uid -g $gid -s /bin/bash -c Developer developer && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    mkdir -p $HOME $CAFFE_ROOT $DVTB_ROOT && \
    chown ${uid}:${gid} -R $HOME $CAFFE_ROOT $DVTB_ROOT

USER developer

WORKDIR /opt/deep-visualization-toolbox

