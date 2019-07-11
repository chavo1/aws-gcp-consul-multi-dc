#!/bin/bash

set -x
export DEBIAN_FRONTEND=noninteractive
CONSUL_TEMPLATE_VERSION="0.20.0"

which consul-template || {
    # install consul-template. 
        pushd /usr/local/bin/
        sudo wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
        sudo unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
        sudo chmod +x consul-template
        popd
}
set +x

