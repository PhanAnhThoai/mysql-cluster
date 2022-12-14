#!/usr/bin/env bash
set -ex

#docker-compose up --build -d

#docker exec -it mysql-cluster_master_1 /scripts/master.sh

#docker exec -it mysql-cluster_slave-1_1 /scripts/slave.sh


./common.sh

# Turn on when run master or slave 
#./scripts/master.sh
./scripts/slave.sh
