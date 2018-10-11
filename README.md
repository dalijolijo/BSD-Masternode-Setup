[![docker pulls](https://img.shields.io/docker/pulls/limxtec/bsd-masternode.svg?style=flat)](https://hub.docker.com/r/limxtec/bsd-masternode/)
# BSD-Masternode-Setup
## OPTION 1: Installation with script

**Rewrite for Ununtu 16.04 + fresh bootstrap to sync within minutes**

You will need masternode genkey output and fresh password for new bitsend user.

Login as root, then do:
```
sudo bash -c "$(curl -fsSL https://github.com/dalijolijo/BSD-Masternode-Setup/raw/master/bsdsetup.sh)"
```

To enable firewall, you have to manually reboot server when blockchain is fully loaded!

Its loaded when "height" in message:
```2018-01-32 24:61:61 UpdateTip: new best=0000000001602844h6h46649ab3cc7d66969e80b2cd970773d355a97bb9ac height=407633 version=0x20000000 log2_work=55.377649 tx=570794 date='2017-12-20 16:26:23' progress=1.000000 cache=0.0MiB(188tx)```

Will be equal to "Current numbers of blocks" in local wallet (gui - help>debug>information).
After server restarts - you are free to enable masternode in local wallet.

## OPTION 2: Deploy as a docker container

Support for the following distribution versions:
* CentOS 7.4 (x86_64-centos-7)
* Fedora 26 (x86_64-fedora-26)
* Fedora 27 (x86_64-fedora-27) - tested
* Fedora 28 (x86_64-fedora-28) - tested
* Debian 7 (x86_64-debian-wheezy)
* Debian 8 (x86_64-debian-jessie) - tested
* Debian 9 (x86_64-debian-stretch) - tested
* Debian 10 (x86_64-debian-buster) - tested
* Ubuntu 14.04 LTS (x86_64-ubuntu-trusty) - tested
* Ubuntu 16.04 LTS (x86_64-ubuntu-xenial) - tested
* Ubuntu 17.10 (x86_64-ubuntu-artful)
* Ubuntu 18.04 LTS (x86_64-ubuntu-bionic) - tested

### Download and execute the docker-ce installation script

Download and execute the automated docker-ce installation script - maintained by the Docker project.

```
sudo curl -sSL https://get.docker.com | sh
```

### Download and start the script
Login as root, then do:

```
sudo bash -c "$(curl -fsSL https://github.com/dalijolijo/BSD-Masternode-Setup/raw/master/bsd-docker.sh)"
```

### For more details to docker related stuff have a look at:
* BSD-Masternode-Setup/BUILD_README.md
* BSD-Masternode-Setup/RUN_README.md


## Visit us at [Telegram](https://t.me/BSD_Bitsend)

## Don't hestitate to join [Discord channel](https://discord.gg/DNfazhS), share your thoughts and ideas with us.
