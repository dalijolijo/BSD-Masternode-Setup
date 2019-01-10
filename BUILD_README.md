# BitSend (BSD) Masternode - Build Docker Image

The Dockerfile will install all required stuff to run a BitSend (BSD) Masternode and is based on script bsdsetup.sh (see: https://github.com/dArkjON/BSD-Masternode-Setup-1604/blob/master/bsdsetup.sh)

## Requirements
- Linux Ubuntu 16.04 LTS
- Running as docker host server (package docker-ce installed)
```
sudo curl -sSL https://get.docker.com | sh
```

## Needed files
- Dockerfile
- bitsend.conf
- bitsend.sv.conf
- start.sh

## Allocating 2GB Swapfile
Create a swapfile to speed up the building process. Recommended if not enough RAM available on your docker host server.
```
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

## Build docker image
```
docker build -t bsd-masternode --build-arg VERSION=0.14.2.0.0 --build-arg RELEASE_TAR=linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz .
```

## Push docker image to hub.docker
```
docker tag bsd-masternode limxtec/bsd-masternode
docker login -u limxtec -p"<PWD>"
docker push limxtec/bsd-masternode:<tag>
```
