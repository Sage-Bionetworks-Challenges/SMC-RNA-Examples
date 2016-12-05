FROM ubuntu:14.04

#Install Essentials
RUN apt-get update
RUN apt-get install -y cmake gcc g++ wget zlib1g-dev libncurses5-dev libpthread-stubs0-dev

WORKDIR /opt

#Install INTEGRATE
RUN wget https://sourceforge.net/projects/integrate-fusion/files/latest/download && \ 
	tar zxvf download && \
	cd INTEGRATE_0_2_6 && \
	mkdir build && \
	cd build && \
	cmake ../Integrate -DCMAKE_BUILD_TYPE=release  && \
	make

ENV PATH /opt/INTEGRATE_0_2_5/build/bin:/usr/bin:/bin