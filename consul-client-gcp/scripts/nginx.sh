#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

IPs=$(hostname -I)
HOST=$(hostname)

sudo killall apt apt-get
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
sudo dpkg --configure -a
sudo apt update -y

which nginx &>/dev/null || {
    sudo apt get update -y
    sudo apt install nginx -y
    }

sudo service nginx stop
# If we need envconsul
if which envconsul >/dev/null; then

echo $nginx > /var/www/html/index.nginx-debian.html

# Another examples
# envconsul -pristine -prefix nginx env | sed 's/consul-client01=//g' > /var/www/html/index.nginx-debian.html
# export `envconsul -pristine -prefix nginx env`; env

# If we consul-template
elif  which consul-template >/dev/null; then
set -x
    export HOST=$HOST
    consul-template -config /tmp/templates/config.hcl > /tmp/template_$HOST.log & 
else
  
  # Updating nginx start page

rm /var/www/html/index.nginx-debian.html
sudo curl -s 127.0.0.1:8500/v1/kv/$HOST/nginx?raw > /var/www/html/index.nginx-debian.html

fi

service nginx start

sudo mkdir -p /etc/consul.d

# create script to check nging welcome page
cat << EOF > /tmp/welcome.sh
#!/usr/bin/env bash
curl 127.0.0.1:80 | grep "Welcome to nginx from ${HOST}!"
EOF
sudo chmod +x /tmp/welcome.sh

#####################
# Register services #
#####################
cat << EOF > /etc/consul.d/web.json
{
    "service": {
        "name": "web",
        "tags": ["${HOST}"],
        "port": 80,
        "check": {
          "args": ["/tmp/welcome.sh", "-limit", "256MB"],
          "interval": "10s"
      }
    },
    "checks": [
      {
          "id": "nginx_http_check",
          "name": "nginx",
          "http": "http://${HOST}:80",
          "tls_skip_verify": false,
          "method": "GET",
          "interval": "10s",
          "timeout": "1s"
      },
      {
          "id": "tcp_check",
          "name": "TCP on port 80",
          "tcp": "127.0.0.1:80",
          "interval": "10s",
          "timeout": "1s"
      }
   ]
}
EOF


consul reload

consul members

set +x
