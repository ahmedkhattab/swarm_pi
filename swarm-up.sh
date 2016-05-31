#!/bin/bash
getip()
{ 
 getent hosts $1 | cut -d' ' -f1 
}

IP_1=$(getip pi1.local)
ssh-keygen -R $IP_1
ssh-copy-id -oStrictHostKeyChecking=no -oCheckHostIP=no root@$IP_1
IP_2=$(getip pi2.local)
ssh-keygen -R $IP_2
ssh-copy-id -oStrictHostKeyChecking=no -oCheckHostIP=no root@$IP_2
IP_3=$(getip pi3.local)
ssh-keygen -R $IP_3
ssh-copy-id -oStrictHostKeyChecking=no -oCheckHostIP=no root@$IP_3
IP_4=$(getip pi4.local)
ssh-keygen -R $IP_4
ssh-copy-id -oStrictHostKeyChecking=no -oCheckHostIP=no root@$IP_4

export TOKEN=$(for i in $(seq 1 32); do echo -n $(echo "obase=16; $(($RANDOM % 16))" | bc); done; echo)

docker-machine create -d generic \
  --engine-storage-driver=overlay --swarm --swarm-master \
  --swarm-image hypriot/rpi-swarm:latest \
  --swarm-discovery="token://$TOKEN" \
  --generic-ip-address=$IP_1 \
pi1

docker-machine create -d generic \
  --engine-storage-driver=overlay --swarm \
  --swarm-image hypriot/rpi-swarm:latest \
  --swarm-discovery="token://$TOKEN" \
  --generic-ip-address=$IP_2 \
pi2

docker-machine create -d generic \
  --engine-storage-driver=overlay --swarm \
  --swarm-image hypriot/rpi-swarm:latest \
  --swarm-discovery="token://$TOKEN" \
  --generic-ip-address=$IP_3 \
pi3

docker-machine create -d generic \
  --engine-storage-driver=overlay --swarm \
  --swarm-image hypriot/rpi-swarm:latest \
  --swarm-discovery="token://$TOKEN" \
  --generic-ip-address=$IP_4 \
pi4

eval $(docker-machine env --swarm pi1)
