source ./Provision/Common/index.sh

if [ $RANCHER_count == 1 ]; then
nodeIP="${machinePrefix}_RANCHER_1"
info "Waiting for Rancher to be ready at: ${!nodeIP}:${RANCHER_https_port}"
      # wait until rancher server is ready
  vagrant ssh ${machinePrefix}-RANCHER-1 -c 'while true; do \
    wget -T 5 --no-check-certificate -c https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/ping && break
    sleep 5 
    done
    rm -rf ping
    ' 
    if [ $? -ne 0 ]; then
      error "Could not check if Rancher is running on Rancher Machine ${machinePrefix}-RANCHER-1"
      exit 1
    fi

  success "Rancher is ready at: ${!nodeIP}:${RANCHER_https_port}"
else
  error "We have not implemented multi-node Rancher deployment...coming soon"
  exit 1
fi 
