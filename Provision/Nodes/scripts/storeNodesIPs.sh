source ./Provision/Common/index.sh

rm -rf ./Provision/Nodes/ips.yaml

info "Getting IPs of the Rancher Nodes"

for ((i=1;i<=$RANCHER_count;i++)); do 
  ip=$(vagrant ssh ${machinePrefix}-RANCHER-${i} -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
  ip="$(echo "${ip}" | tr -d '[:space:]')"
  echo "${machinePrefix}_RANCHER_${i}: $ip" >> "./Provision/Nodes/ips.yaml"
done

info "Getting IPs of the Worker Nodes"

for ((i=1;i<=$WORKER_count;i++)); do 
  ip=$(vagrant ssh ${machinePrefix}-WORKER-${i} -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
  ip="$(echo "${ip}" | tr -d '[:space:]')"
  
  echo "${machinePrefix}_WORKER_${i}: $ip" >> "./Provision/Nodes/ips.yaml"
done

info "Getting IPs of the LoadBalancer Nodes"

for ((i=1;i<=$LOADBALANCER_count;i++)); do 
  ip=$(vagrant ssh ${machinePrefix}-LOADBALANCER-${i} -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
  ip="$(echo "${ip}" | tr -d '[:space:]')"
  
  echo "${machinePrefix}_LOADBALANCER_${i}: $ip" >> "./Provision/Nodes/ips.yaml"
done



if [ -f ./Provision/Nodes/ips.yaml ]; then
  success "IP addresses stored at ./Provision/Nodes/ips.yaml"
else
  error "Could not create ips.yaml file. Exiting"
  exit 1
fi


