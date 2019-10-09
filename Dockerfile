# BitSend (BSD) Masternode - Dockerfile (05-2018)
#
# The Dockerfile will install all required stuff to run a BitSend (BSD) Masternode and is based on script bsdsetup.sh (see: https://github.com/dArkjON/BSD-Masternode-Setup-1604/blob/master/bsdsetup.sh)
# BitSend Repo : https://github.com/LIMXTEC/BitSend
# E-Mail: info@bitsend.info
# 
# To build a docker image for bsd-masternode from the Dockerfile the bitsend.conf is also needed.
# See BUILD_README.md for further steps.

# Use an official Ubuntu runtime as a parent image
FROM ubuntu:16.04

LABEL maintainer="Jon D. (dArkjON), David B. (dalijolijo)"

ARG VERSION=0.14.2.0.0
ENV VERSION=${VERSION}
RUN echo ${VERSION}

ARG RELEASE_TAR=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
ENV RELEASE_TAR=${RELEASE_TAR}
RUN echo ${RELEASE_TAR}

# Make ports available to the world outside this container
# DefaultPort = 8886
# RPCPort = 8800
# TorPort = 9051
# DEPRECATED: Use 'docker run -p 8800:8800 -p 8886:8886 -p 9051:9051 ...'
#EXPOSE 8800 8886 9051

USER root

# Change sh to bash
SHELL ["/bin/bash", "-c"]

# Define environment variable
ENV BSDPWD "bitsend"

RUN echo '*** BitSend (BSD) Masternode ***'

#
# Creating bitsend user
#
RUN echo '*** Creating bitsend user ***' && \
    adduser --disabled-password --gecos "" bitsend && \
    usermod -a -G sudo,bitsend bitsend && \
    echo bitsend:$BSDPWD | chpasswd

#
# Running updates and installing required packages
#
RUN echo '*** Running updates and installing required packages ***' && \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  apt-utils \
                        autoconf \
                        automake \
                        autotools-dev \
			bsdmainutils \
                        build-essential \
                        curl \
                        git \
                        libboost-all-dev \
                        libevent-dev \
                        libminiupnpc-dev \
                        libssl-dev \
                        libtool \
                        libzmq5-dev \
                        pkg-config \
			python3 \
                        software-properties-common \
                        sudo \
                        supervisor \
                        vim \
                        wget && \
    add-apt-repository -y ppa:bitcoin/bitcoin && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y  libdb4.8-dev \
                        libdb4.8++-dev

#
# Cloning and Compiling BitSend Wallet
#
RUN echo '*** Cloning and Compiling BitSend Wallet ***' && \
    cd && \
    echo "Execute a git clone of LIMXTEC/BitSend. Please wait..." && \
    git clone --branch 0.18 https://github.com/dalijolijo/BitSend && \
    cd BitSend && \
    ./autogen.sh && \
    ./configure --disable-hardening --disable-dependency-tracking --enable-tests=no --without-gui && \
    make && \
    make install
RUN cd && \
    cd BitSend/src && \
    ls && \
    strip bitsendd && \
    cp bitsendd /usr/local/bin && \
    strip bitsend-cli && \
    cp bitsend-cli /usr/local/bin && \
    chmod 775 /usr/local/bin/bitsend* && \   
    cd && \
    rm -rf BitSend

#
# Download BitSend release
#
#RUN echo '*** Download BitSend release ***' && \
#    mkdir -p /root/src && \
#    cd /root/src && \
#    wget https://github.com/LIMXTEC/BitSend/releases/download/${VERSION}/${RELEASE_TAR} && \
#    tar xzf *.tar.gz && \
#    chmod 775 bitsend* && \
#    cp bitsend* /usr/local/bin && \
#    rm *.tar.gz

#
# Copy Supervisor Configuration and bitsend.conf
#
RUN echo '*** Copy Supervisor Configuration and bitsend.conf ***'
COPY *.sv.conf /etc/supervisor/conf.d/
COPY bitsend.conf /tmp

#
# Copy start script
#
RUN echo '*** Copy start script ***'
COPY start.sh /usr/local/bin/start.sh
RUN rm -f /var/log/access.log && mkfifo -m 0666 /var/log/access.log && \
    chmod 755 /usr/local/bin/*

ENV TERM linux
CMD ["/usr/local/bin/start.sh"]
