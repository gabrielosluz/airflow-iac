#!/bin/bash
set -Eeuxo pipefail

# as root
cd /tmp &&
#echo "updating packages"
yum update -y &&
echo "installing docker"
amazon-linux-extras install docker &&
usermod -a -G docker ec2-user &&
systemctl enable --now docker &&
echo "vm.max_map_count=262144" >> /etc/sysctl.conf &&


echo "installing docker compose"
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose &&
chmod +x /usr/local/bin/docker-compose &&
yum install git -y &&

# Docker-compose start
sysctl -w vm.max_map_count=262144