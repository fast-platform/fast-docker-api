source ./Provision/Common/index.sh

info "Resuming Rancher Nodes"

for ((i=1;i<=$RANCHER_count;i++)); do 
  vagrant resume ${machinePrefix}-RANCHER-${i}
done

info "Resuming Worker Nodes"

for ((i=1;i<=$WORKER_count;i++)); do 
  vagrant resume ${machinePrefix}-WORKER-${i}
done

info "Resuming LoadBalancer Nodes"

for ((i=1;i<=$LOADBALANCER_count;i++)); do 
  vagrant resume ${machinePrefix}-LOADBALANCER-${i}
done