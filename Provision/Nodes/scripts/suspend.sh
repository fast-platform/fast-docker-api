source ./Provision/Common/index.sh

info "Turning Rancher Nodes off"

for ((i=1;i<=$RANCHER_count;i++)); do 
  vagrant suspend ${machinePrefix}-RANCHER-${i}
done

info "Turning Worker Nodes off"

for ((i=1;i<=$WORKER_count;i++)); do 
  vagrant suspend ${machinePrefix}-WORKER-${i}
done

info "Turning LoadBalancer Nodes off"

for ((i=1;i<=$LOADBALANCER_count;i++)); do 
  vagrant suspend ${machinePrefix}-LOADBALANCER-${i}
done