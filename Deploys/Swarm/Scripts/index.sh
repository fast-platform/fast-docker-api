#!/bin/bash
# Main source of information to develop this script!
#https://github.com/devteds/swarm-portworx-consul
NumberOfNodes=2
createMachines=no
source "$(dirname $0)/common.sh"
echo "We currently are in"

echo "$YELLOW Checking if docker-machine is installed $NC"
command -v docker-machine >/dev/null 2>&1 || { echo >&2 "$RED FAILED $NC - 'docker-machine' is not installed on this host, please install it.  Aborting."; exit 1; }
echo "$GREEN OK - $NC 'docker-machine' is installed $NC"

echo "$YELLOW Checking if VirtualBox is installed $NC"
command -v VBoxManage >/dev/null 2>&1 || { echo >&2 "$RED FAILED $NC - 'VirtualBox' is not installed on this host, please install it.  Aborting."; exit 1; }
echo "$GREEN OK - $NC VBoxManage is installed $NC"

echo "$YELLOW Checking previous nodes running $NC"

for ((i=1;i<=$NumberOfNodes;i++)); do 
    command docker-machine status fs-$i > /dev/null 2>&1 || { createMachines=yes; }	
done

if [ "$createMachines" == "no" ] ; then
	echo "$GREEN OK - $NC All machines are already running $NC"
elif [ "$createMachines" == "yes" ]; then
    echo "$BLUE INFO - $NC Machines not found. $NC"
    echo "$BLUE INFO - $NC Creating machines to start the cluster, this takes a couple minutes $NC"
    echo "$BLUE INFO - $NC Good idea to go for a coffee now! I'll take care of the rest...$NC"

	for ((i=1;i<=$NumberOfNodes;i++)); do 
    #run_or_exit "Creating fs-$i" "docker-machine create --driver virtualbox --virtualbox-disk-size 40000 --virtualbox-memory 2572 fs-$i"
        vagrant up
    done
    echo "$GREEN OK - $NC All machines are already running $NC"



    echo "$BLUE INFO - $NC Getting IP of the manager node"
    manager_ip=$(vagrant ssh fs-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
    echo "$BLUE INFO - $NC Manager private ip: $manager_ip"

    echo "$BLUE INFO - $NC Creating Swarm Worker"
    echo "$BLUE INFO - $NC Getting Worker token for the Swarm"
          worker_token=$(vagrant ssh fs-1 -c "docker swarm join-token worker -q")
    echo "$GREEN OK - $NC Worker token: $worker_token $NC"
    echo " "
    echo "$BLUE INFO - $NC Attaching the worker nodes to the Swarm"
    manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"
    worker_token="$(echo "${worker_token}" | tr -d '[:space:]')"
    

    for ((i=2;i<=$NumberOfNodes;i++)); do 
        vagrant ssh fs-$i -c "docker swarm join --token $worker_token $manager_ip:2377"
    done
    
    echo "$BLUE INFO - $NC Displaying Swarm nodes"
    vagrant ssh fs-1 -c 'docker node ls'

    echo "$BLUE INFO - $NC Creating network from Swarm leader FS-1"
    vagrant ssh fs-1 -c 'docker network create -d overlay --attachable core-infra'
    echo "$GREEN OK - $NC Network created $NC"

    echo "$BLUE INFO - $NC Labeling DATA nodes"
    for ((i=2;i<=$NumberOfNodes;i++)); do 
        vagrant ssh fs-1 -c "docker node update --label-add data=true fs-$i"
    done
    echo "$GREEN OK - $NC Data nodes now have label data=true $NC"

    echo "$BLUE INFO - $NC Deploying consul-cluster on Docker Swarm"
    vagrant ssh fs-1 -c "docker stack deploy -c /vagrant/Deploys/Swarm/Stacks/consul.yml consul-cluster"
    
    echo "$GREEN OK - $NC Consul cluster up and running $NC"

    # echo "$BLUE INFO - $NC Attaching Data volumes for the nodes"
    
    # Install volume on the nodes
    #for ((i=1;i<=$NumberOfNodes;i++)); do 
    #    disk="$PWD/Volumes/fs-storage-$i.vdi"
    #    echo "on fs-$i"
    #    VBoxManage createhd --filename $disk --size 5768
    #    VBoxManage storageattach fs-storage-$i --storagectl "IDE Controller" --device 0 --port 2 --type hdd --medium $disk
    #    echo "$BLUE INFO - $NC Waiting for disk to mount on FS-$i"
    #    sleep 5
    #    vagrant ssh -c fs-$i '( echo o; echo n; echo p; echo 1; echo; echo; echo w;) | sudo fdisk /dev/sdb'
    #done

fi
echo "$GREEN OK - $NC All machines are up and running $NC"

echo "$YELLOW Installing PortWorx $NC"

sh ./Deploys/Swarm/Scripts/px_setup.sh FastCluster /dev/sdb

sh ./Deploys/Swarm/Scripts/portainer.sh

sh ./Deploys/Swarm/Scripts/getLeader.sh