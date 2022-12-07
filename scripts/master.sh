#!/usr/bin/env bash
set -ex
IP_MASTER=${IP_MASTER:-}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
MYSQL_SLAVE_PASSWORD=${MYSQL_SLAVE_PASSWORD:-slave}
ENDIP=$(ip addr show ens33 | grep 'inet ' | sed -E 's/\s+inet ([0-9.]+)\/[0-9]+ .*/\1/g' | head -n 1 | sed -E 's/^([0-9].+)([{.}])([0-9]+)$/\3/g')
service mysql restart
while :; 
do
  if nc -z localhost 3306
  then
    break
  else
    sleep 1
  fi
done

if [ $(echo 'select Host from mysql.user where User = "root"' | mysql -N) == localhost ]; then
  echo 'UPDATE mysql.user SET Host = "%" where User = "root"'| mysql
fi

if [ -z $(echo 'select Password from mysql.user where User = "root"' | mysql -N) ]; then
  echo "ALTER USER \"root\"@\"%\" IDENTIFIED BY \"$MYSQL_ROOT_PASSWORD\"" | mysql
fi

if [ -z $(echo 'select Host from mysql.user where User="slave"' | mysql) ]; then
  echo "CREATE USER \"slave\"@\"%\" IDENTIFIED BY \"$MYSQL_SLAVE_PASSWORD\"" | mysql
  echo "GRANT REPLICATION SLAVE ON *.* TO \"slave\"@\"%\"" | mysql
fi

sed -i -E "s/^#server-id += [0-9]$/server-id           =$ENDIP/g" /etc/mysql/mariadb.conf.d/50-server.cnf

service mysql restart