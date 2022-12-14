#!/usr/bin/env bash
set -ex
IP_MASTER=${IP_MASTER:-}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
MYSQL_SLAVE_PASSWORD=${MYSQL_SLAVE_PASSWORD:-slave}
ENDIP=$(ip addr show eth0 | grep 'inet ' | sed -E 's/\s+inet ([0-9.]+)\/[0-9]+ .*/\1/g' | head -n 1 | sed -E 's/^([0-9].+)([{.}])([0-9]+)$/\3/g')
# If use docker run mysql no need use service mysql start
#service mysql start

while :; 
do
  if nc -z localhost 3306
  then
    break
  else
    sleep 1
  fi
done

echo "CREATE USER root@\"%\" IDENTIFIED BY \"$MYSQL_ROOT_PASSWORD\"" | mysql

if [ -z $(echo 'select Host from mysql.user where User="slave"' | mysql) ]; then
  echo "CREATE USER \"slave\"@\"%\" IDENTIFIED BY \"$MYSQL_SLAVE_PASSWORD\"" | mysql
  echo "GRANT REPLICATION SLAVE ON *.* TO \"slave\"@\"%\"" | mysql
fi

sed -i -E "s/^#server-id += [0-9]$/server-id           =$ENDIP/g" /etc/mysql/mariadb.conf.d/50-server.cnf

service mysql restart