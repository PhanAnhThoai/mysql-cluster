#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive

#apt-get update

apt install -y systemd systemd-sysv kmod coreutils lsb-release wget curl zip unzip tar busybox iputils-ping iproute2 net-tools jq gnupg2 netcat bind9-dnsutils openssh-client git binutils ripgrep bash-completion

apt install -y mariadb-server

curl https://getmic.ro | bash && mv micro /usr/local/bin

sed -i -E 's/^(bind-address += )([0-9].+)$/\1 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

sed -i -E "s/^#(log_bin +=)(.*$)/\1\2/g" /etc/mysql/mariadb.conf.d/50-server.cnf