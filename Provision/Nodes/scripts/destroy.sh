source ./Provision/Common/index.sh

rm -rf ./Provision/Nodes/ips.yaml

info "Deleting Rancher Nodes"

for ((i=1;i<=$RANCHER_count;i++)); do 
  vagrant destroy -f ${machinePrefix}-RANCHER-${i}
done

info "Deleting Worker Nodes"

for ((i=1;i<=$WORKER_count;i++)); do 
  vagrant destroy -f ${machinePrefix}-WORKER-${i}
done

info "Deleting LoadBalancer Nodes"

for ((i=1;i<=$LOADBALANCER_count;i++)); do 
  vagrant destroy -f ${machinePrefix}-LOADBALANCER-${i}
done