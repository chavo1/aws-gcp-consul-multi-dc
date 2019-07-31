#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get install dnsmasq -y
sudo systemctl stop dnsmasq
#######################################################################
# Consul DNS, to be resolved in the consul domain as well as external #
#######################################################################
sudo echo "server=/consul/127.0.0.1#8600" > /etc/dnsmasq.d/10-consul

sudo sed -i 's/#resolv-file=/resolv\-file=\/etc\/dnsmasq.d\/external.conf/g' /etc/dnsmasq.conf

cat <<EOF > /etc/dnsmasq.d/external.conf
server=8.8.8.8
EOF

sudo systemctl start dnsmasq
