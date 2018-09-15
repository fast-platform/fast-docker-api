#!/bin/bash

source "$(dirname $0)/common.sh"

NumberOfNodes=2
# Install volume on two nodes
latest_stable=$(curl -fsSL 'https://install.portworx.com/1.3/?type=dock&stork=false' | awk '/image: / {print $2}')

# Install Portworx runC on node 2 & 3
for ((i=2;i<=$NumberOfNodes;i++)); do 
    vagrant ssh fs-$i -c "docker run --entrypoint /runc-entry-point.sh --rm -i --privileged=true -v /opt/pwx:/opt/pwx -v /etc/pwx:/etc/pwx $latest_stable"
done

px_cluster_id=$1
storage_device=$2

echo "$GREEN#####################################"

echo "Cluster ID: $px_cluster_id"
echo "New Volume: $storage_device"

echo "#####################################$NC"

swarm_manager_private_ip=$(vagrant ssh fs-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
swarm_manager_private_ip="$(echo "${swarm_manager_private_ip}" | tr -d '[:space:]')"
# Install volume on two nodes
for ((i=2;i<=$NumberOfNodes;i++)); do 
    echo "on fs-$i"
    vagrant ssh fs-$i -c "sudo /opt/pwx/bin/px-runc install -c $px_cluster_id -k consul:http://$swarm_manager_private_ip:8500 -s $storage_device"
done

# Reload daemon and enable start px
for ((i=2;i<=$NumberOfNodes;i++)); do 
    vagrant ssh fs-$i -c "sudo systemctl daemon-reload"
    echo "Waiting for deamon to reload...10seg"
	sleep 10
    vagrant ssh fs-$i -c "sudo systemctl enable portworx.service"
    echo "Waiting for portworx service to be enabled...20seg"
	sleep 20
    vagrant ssh fs-$i -c "sudo systemctl start portworx.service"
done
    echo "Waiting for portworx service to be restart...20seg"
	sleep 20
    
echo "$GREEN#######################################"
echo "CLUSTER UP AND READY!! - HAVE FUN!"
echo "#######################################$NC"