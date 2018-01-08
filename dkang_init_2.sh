#!/bin/bash

# Change package source list
sudo sed -e "s/archive.ubuntu.com/ftp.daumkakao.com/g" -i /etc/apt/sources.list

# Update package lists
sudo apt-get update -y
sudo apt-get upgrade -y

# X11 app and fonts install
sudo apt-get install x11-apps xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic -y

# Korean language pack install
sudo apt-get install language-pack-ko -y
sudo locale-gen ko_KR.UTF-8
sudo apt-get install mesa-utils fonts-unfonts-core fonts-unfonts-extra fonts-baekmuk fonts-nanum fonts-nanum-coding fonts-nanum-extra -y

# Korean language setting
sudo apt-get install unfont* -y
sudo apt-get install fcitx-hangul -y

# ssh setting
sudo apt-get install ssh xauth xorg -y

# Install Utils
sudo apt-get install firefox evince eog htop -y

# Necessary packages
sudo apt-get install perl python vim gnuplot -y

# CERN ROOT Prerequisites
sudo apt-get install git dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev build-essential -y
# Optional packages
sudo apt-get install gfortran libssl-dev libpcre3-dev xlibmesa-glu-dev libglew1.5-dev libftgl-dev -y
sudo apt-get install libmysqlclient-dev libfftw3-dev libcfitsio-dev graphviz-dev libavahi-compat-libdnssd-dev -y
sudo apt-get install libldap2-dev python-dev libxml2-dev libkrb5-dev libgsl-dev libqt4-dev -y
sudo apt-get install libjpeg-dev libtiff4-dev libpng12-dev freeglut3-dev libxmu-dev libgif-dev libiodbc2 libiodbc2-dev -y
sudo apt-get install gdb cmake-curses-gui -y
sudo apt-get install autoconf automake autotools-dev -y

# CalcHEP
sudo apt-get install libx11-dev -y

# PYTHIA
sudo apt-get install libboost-dev zlib1g-dev gzip -y

# fastjet3
sudo apt-get install libcgal-dev swig -y

# Python packages
sudo apt-get install python-numpy python-scipy python-matplotlib python-pandas python-pip -y

# ssh config 
sudo sed -e "s/#   ForwardAgent no/    ForwardAgent yes/" -i /etc/ssh/ssh_config
sudo sed -e "s/#   ForwardX11 no/    ForwardX11 yes/" -i /etc/ssh/ssh_config
sudo sed -e "s/#   ForwardX11Trusted.*/    ForwardX11Trusted yes/" -i /etc/ssh/ssh_config
sudo sed -e "s/#   Port.*/    Port 22/" -i /etc/ssh/ssh_config
sudo sed -e "s/#   Protocol.*/    Protocol 2/" -i /etc/ssh/ssh_config
sudo echo "    XauthLocation /usr/bin/xauth" >> /etc/ssh/ssh_config


######################
# Download HEP Tools #
######################
# Install CERN ROOT
#cd /usr/local
#sudo git clone http://root.cern.ch/git/root.git root_src
#cd root_src
#git checkout -b v6-08-06 v6-08-06
#cd ..
#sudo mkdir root
#cd root
#sudo cmake ../root_src
#sudo cmake --build . -- -j2
#sudo make install
#cd

mkdir HEP_Tools
cd HEP_Tools

# Install fastjet
wget http://fastjet.fr/repo/fastjet-3.3.0.tar.gz
tar -zxvf fastjet-3.3.0.tar.gz
cd fastjet-3.3.0
./configure --enable-allplugins --enable-pyext --enable-swig --enable-cgal
sudo make -j
sudo make check
sudo make install
cd ..

# Install MadGrpah5
wget https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v2.6.1.tar.gz
tar -xzvf MG5_aMC_v2.6.1.tar.gz MG5_aMC
cd MG5_aMC
touch install.log
echo "install pythia8" >> install.log
echo "install Delphes" >> install.log
echo "install ExRootAnalysis" >> install.log
echo "install collier" >> install.log
echo "install ninja" >> install.log
echo "install oneloop" >> install.log
./bin/mg5_aMC install.log
rm install.log
cd ..

# Install CalcHep
wget http://theory.sinp.msu.ru/~pukhov/CALCHEP/calchep_3.6.30.tgz
tar -xzvf calchep_3.6.30.tgz
cd calchep_3.6.30
make
cd ..

# Install Micromegas
wget https://lapth.cnrs.fr/micromegas/downloadarea/code/micromegas_4.3.5.tgz
tar -xzvf micromegas_4.3.5.tgz
cd micromegas_4.3.5
make
cd ..

# Install OptiMass
wget http://hep-pulgrim.ibs.re.kr/optimass/download/OptiMass-v1.0.3.tar.gz
tar -xzvf OptiMass-v1.0.3.tar.gz
cd OptiMass-v1.0.3
cd alm_base
./configure
make
make install
cd ../../

# Delete tar files
rm *.tar.gz
rm *.tgz

