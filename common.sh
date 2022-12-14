#!/usr/bin/env bash
set -ex

# Turn on export DEBIAN_FRONTEND=noninteractive if docker run mysql
#export DEBIAN_FRONTEND=noninteractive

sudo apt update

sudo apt install -y systemd systemd-sysv kmod coreutils lsb-release wget curl zip unzip tar busybox iputils-ping iproute2 net-tools jq gnupg2 netcat bind9-dnsutils openssh-client git binutils ripgrep bash-completion

sudo apt install -y mariadb-server

#curl https://getmic.ro | bash && mv micro /usr/local/bin

sudo sed -i -E 's/^(bind-address += )([0-9].+)$/\1 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

sudo sed -i -E "s/^#(log_bin +=)(.*$)/\1\2/g" /etc/mysql/mariadb.conf.d/50-server.cnf
