#!/bin/bash

mkdir install-more-tools
cd install-more-tools

HUMCTL_VERSION=$(curl -sL https://api.github.com/repos/humanitec/cli/releases/latest | jq -r .tag_name)
curl -fLO https://github.com/humanitec/cli/releases/download/${HUMCTL_VERSION}/cli_${HUMCTL_VERSION:1}_linux_amd64.tar.gz
tar -xvf cli_${HUMCTL_VERSION:1}_linux_amd64.tar.gz
chmod +x humctl
sudo mv humctl /usr/local/bin/humctl

cd ..
rm -rf install-more-tools