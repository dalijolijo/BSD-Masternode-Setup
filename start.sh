#!/bin/bash
set -u

CONFIG=${CONFIG_PATH}/bitsend.conf
CONFIG_REUSE=${CONFIG_PATH}/.bitsend.conf

#
# Downloading bitsend.conf
#
cd /tmp/
wget https://raw.githubusercontent.com/dalijolijo/BSD-Masternode-Setup/master/bitsend.conf -O /tmp/bitsend.conf
chown bitsend:bitsend /tmp/bitsend.conf

#
# Configure bitsend.conf
#
printf "** Configure bitsend.conf ***\n"
mkdir -p ${CONFIG_PATH}
chown -R bitsend:bitsend /home/bitsend/

if [ -f ${CONFIG_REUSE} ] ; then
	sudo -u bitsend mv ${CONFIG_REUSE} ${CONFIG}
else
	printf "** Set rpcuser, rpcpassword and masternode genkey ***\n"
	sudo -u bitsend cp /tmp/bitsend.conf ${CONFIG}
	sed -i "s#^\(rpcuser=\).*#rpcuser=bsd$(openssl rand -base64 32 | tr -d '[:punct:]')#g" ${CONFIG}
	sed -i "s#^\(rpcpassword=\).*#rpcpassword=$(openssl rand -base64 32 | tr -d '[:punct:]')#g" ${CONFIG}
	sed -i "s|^\(masternode=\).*|masternode=${MASTERNODE}|g" ${CONFIG}
	sed -i "s|^\(txindex=\).*|txindex=${TXINDEX}|g" ${CONFIG}
	sed -i "s|^\(masternodeprivkey=\).*|masternodeprivkey=${MN_KEY}|g" ${CONFIG}
	sed -i "s|^\(externalip=\).*|externalip=${BSD_IP}|g" ${CONFIG}
	RPC_ALLOWIP=$(ip addr | grep 'global eth0' | xargs | cut -f2 -d ' ')
	sed -i "s#^\(rpcallowip=\).*#rpcallowip=${RPC_ALLOWIP}#g" ${CONFIG}
fi

#
# Downloading bootstrap file
#
printf "** Downloading bootstrap file ***\n"
cd ${CONFIG_PATH}
if [ ! -d ${CONFIG_PATH}/blocks ] && [ "$(curl -Is https://${WEB}/${BOOTSTRAP} | head -n 1 | tr -d '\r\n')" = "HTTP/1.1 200 OK" ] ; then \
        sudo -u bitsend wget https://${WEB}/${BOOTSTRAP}; \
        sudo -u bitsend tar -xvzf ${BOOTSTRAP}; \
        sudo -u bitsend rm ${BOOTSTRAP}; \
fi

#
# Step Starting BitSend Service
#
# Hint: docker not supported systemd, use of supervisord
printf "*** Starting BitSend Service ***\n"
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
