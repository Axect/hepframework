FROM fedora:latest
MAINTAINER Axect<edeftg@gmail.com>
LABEL description="HEP-COSMO framework"

# Prerequisites for ROOT
RUN dnf update -y
RUN dnf install -y git cmake gcc-c++ gcc binutils findutils wget\
	   libX11-devel libXpm-devel libXft-devel libXext-devel \
	   python3 python3-devel python3-pip \ 
	   gcc-gfortran openssl-devel pcre-devel \
	   mesa-libGL-devel mesa-libGLU-devel glew-devel ftgl-devel mysql-devel \
	   fftw-devel cfitsio-devel graphviz-devel \
	   avahi-compat-libdns_sd-devel python-devel \
	   libxml2-devel \
	   boost-devel zlib-devel gzip \
	   CGAL-devel swig firefox

# Python Install
RUN pip3 install --upgrade pip && pip3 install jupyter \
	    numpy \
	    scipy \
	    matplotlib \
	    pandas \
	    zmq

# Set ROOT environment
ARG ROOT_VERSION="6.12.04"
ARG FSTJET_VERSION="3.3.0"
ARG MG5_VERSION="2.6.1"
ARG MG5_VERSION2="2_6_1"
ARG CHEP_VERSION="3.6.30"
ARG MICRO_VERSION="4.3.5"
ARG OPTMASS_VERSION="1.0.3"

ENV ROOTSYS         "/opt/root"
ENV fastjet 	    "/opt/fastjet-${FSTJET_VERSION}"
ENV PATH            "$ROOTSYS/bin:$fastjet/include:$PATH"
ENV LD_LIBRARY_PATH "$ROOTSYS/lib:$fastjet/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH      "$ROOTSYS/lib:$PYTHONPATH"

# ROOT Binary for Fedora 27
ADD https://root.cern.ch/download/root_v${ROOT_VERSION}.Linux-fedora27-x86_64-gcc7.2.tar.gz /var/tmp/root.tar.gz
RUN tar xzf /var/tmp/root.tar.gz -C /opt && rm /var/tmp/root.tar.gz

# Download Extra HEP_TOOLS
RUN wget http://fastjet.fr/repo/fastjet-${FSTJET_VERSION}.tar.gz -O /var/tmp/fstjet.tar.gz
RUN wget https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v${MG5_VERSION}.tar.gz -O /var/tmp/mg5.tar.gz
RUN wget http://theory.sinp.msu.ru/~pukhov/CALCHEP/calchep_${CHEP_VERSION}.tgz -O /var/tmp/calchep.tgz
RUN wget https://lapth.cnrs.fr/micromegas/downloadarea/code/micromegas_${MICRO_VERSION}.tgz -O /var/tmp/micromegas.tgz
RUN wget http://hep-pulgrim.ibs.re.kr/optimass/download/OptiMass-v${OPTMASS_VERSION}.tar.gz -O /var/tmp/optimass.tar.gz

# Extract Extra HEP_TOOLS
RUN tar xzf /var/tmp/fstjet.tar.gz -C /opt && rm /var/tmp/fstjet.tar.gz
RUN tar xzf /var/tmp/mg5.tar.gz -C /opt && rm /var/tmp/mg5.tar.gz
RUN tar xzf /var/tmp/calchep.tgz -C /opt && rm /var/tmp/calchep.tgz
RUN tar xzf /var/tmp/micromegas.tgz -C /opt && rm /var/tmp/micromegas.tgz
RUN tar xzf /var/tmp/optimass.tar.gz -C /opt && rm /var/tmp/optimass.tar.gz

# Build Extra HEP_TOOLS
## FSTJET
WORKDIR /opt/fastjet-${FSTJET_VERSION}
RUN ./configure --enable-allplugins --enable-pyext --enable-swig --enable-cgal
RUN make -j 4
RUN make check
RUN make install

## Reinstall which
RUN dnf install -y which

## CalcHep
WORKDIR /opt/calchep_${CHEP_VERSION}
RUN make

## Micromegas
WORKDIR /opt/micromegas_${MICRO_VERSION}
RUN make

## OptiMass
WORKDIR /opt/OptiMass-v${OPTMASS_VERSION}/alm_base
RUN ./configure
RUN make
RUN make install

WORKDIR /opt

RUN echo "Installation Complte!"

