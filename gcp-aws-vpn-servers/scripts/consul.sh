#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

export IPs=$(hostname -I)
export HOST=$(hostname)
export DC="gcp"

sudo killall consul
sudo mkdir -p /etc/consul.d/ /opt/consul/

# ###########################
# # Starting consul servers #
# ###########################
if [[ $IPs =~ 172.31.16 ]]; then # if 172.31.16 it is dc1
    DC_RANGE_OP="172.31.32"
    DC_RANGE="172.31.16"
elif [[ $IPs =~ 172.31.32 ]]; then  # if 172.31.32 it is dc2
    DC_RANGE_OP="172.31.16"
    DC_RANGE="172.31.32"
else 
    DC_RANGE_OP="172.31.32"
    DC_RANGE="172.31.48"
fi   

NODE_TYPE=client
WAN=""
# Cloud Auto-joining 
# LAN=", \"retry_join\": [ \"provider=aws tag_key=consul tag_value=app\" ]"
# Joining with private IPs
LAN=", \"retry_join\": [ \"$DC_RANGE.11\", \"$DC_RANGE.12\", \"$DC_RANGE.13\" ]"
# WAN=", \"retry_join_wan\": [ \"$DC_RANGE_OP.11\", \"$DC_RANGE_OP.12\", \"$DC_RANGE_OP.13\" ]"

# if the name contain ip-172-31-*-1 we are on server
if [[ $HOST =~ ip-172-31-16-1 || $HOST =~ ip-172-31-32-1 || $HOST =~ ip-172-31-48-1 ]]; then
  NODE_TYPE=server
  # WAN=", \"retry_join_wan\": [ \"provider=aws tag_key=consul_wan tag_value=wan_app\" ]"
  # Joining with private IPs
  WAN=", \"retry_join_wan\": [ \"$DC_RANGE_OP.11\", \"$DC_RANGE_OP.12\", \"$DC_RANGE_OP.13\" ]"
fi

sudo cat <<EOF > /etc/consul.d/config.json
{ 
  "datacenter": "${DC}",
  "ui": true,
  "client_addr": "0.0.0.0",
  "bind_addr": "0.0.0.0",
  "advertise_addr": "${IPs}",
  "enable_script_checks": true,
  "data_dir": "/opt/consul"${LAN}${WAN}
}
EOF

sudo chown -R consul:consul /etc/consul.d/
sudo chmod -R 775 /etc/consul.d/

###################
# Starting Consul #
###################
sudo systemctl daemon-reload
sudo systemctl start consul

###########################
# Redirecting conslul log #
###########################
    if [ -d /opt/consul ]; then
        mkdir -p /opt/consul/consul_logs
        journalctl -f -u consul.service &> /opt/consul/consul_logs/${HOST}.log &
    else
        journalctl -f -u consul.service > /tmp/consul.log
    fi
echo consul started
set +x
sleep 10
consul members
