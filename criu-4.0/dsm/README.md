
## Pre-requisites

This was a fresh install on a new VM with Ubuntu 20.04
If you have another system, consult:https://criu.org/Installation
``` 
sudo apt update
sudo apt install -y \
git \
build-essential \
pkg-config \
libprotobuf-c-dev \
protobuf-c-compiler \
libprotobuf-dev \
protobuf-compiler \
libnl-3-dev \
libnet-dev \
libcap-dev \
libaio-dev \
libpcre3-dev \
python3-future \
python3-protobuf \
python3-pytest \
libbsd-dev \
libseccomp-dev \
asciidoc \
xmlto \
man \
iproute2 \
python3-docutils \
libnftnl-dev \
libnetfilter-conntrack-dev \
libnfnetlink-dev \
gcc \
make \
gdb \
strace \
ltrace \
cmake \
autoconf \
automake \
libtool \
curl \
wget \
unzip \
tar \
vim \
nano \
htop \
net-tools \
iputils-ping \
sudo \
bash-completion \
lsb-release \
software-properties-common \
python3-pip libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler protobuf-compiler python3-protobuf libnl-3-dev libcap-dev uuid-dev

```
# Installation instruction 
As for the https://criu.org/Installation installation 
1. Run ```make``` in the CRIU source directory.
2. Run ```make``` in the ```dsm_client``` and ```dsm/dsm_test``` directories.
3. Installing CRIU works perfectly even when run from the sources directory (with the ```./criu/criu``` command), but if you want to have in standard paths run ``make install``. You may need to install ``asciidoc`` and ``xmlto`` packages to make install-man work.

# Checking installation
So the first thing to do is to check the kernel by running ``criu check``. At the end it should say "Looks OK", if it doesn't the messages on the screen explain what functionality is missing.

# Tests scripts
This page explains the procedure to setup virtual machines for lazy-pages
## 0. VMs
You will need two VMs with the CRIU successfully isntalled. 
## 1. Host connection
Update your host with .ssh/config file by adding these configurations and check the connection
```
Host dsm_server
    HostName src_ip_address
    Port 22
    User <username>
    IdentityFile ~/.ssh/id_rsa

Host dsm_client
    HostName dst_ip_address
    Port 22
    User <username>
    IdentityFile ~/.ssh/id_rsa
   
```

# 2. Testing scripts

### VM1 dsm_server

0. Make sure that you run ```make``` in the ```dsm/dsm_test``` directory.
1. Run `~/fork/dsm/dsm_script/test.sh`with argument either `counter` or `reader` and the time we want to allow the code to run

### VM2 dsm_client
0. Make sure that you run ```make``` in the ```dsm/dsm_scripts``` directory. Check for dump file in ``~/dump`` with ``ls ~/dump``
1. Open 2 connections or use 2 tmux windows/panes
2. In one window launch ``~/fork/dsm/dsm_script/client.sh`` and you should see the program restaring from the interrupted values
3. With the other we can interrupt and clean all the processes with ``~/fork/dsm/dsm_scripts/cleaner.sh``