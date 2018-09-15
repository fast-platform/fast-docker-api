  source ./Provision/Common/index.sh
 
  step "Starting $deployment node environment"
  
  sh ./Provision/Nodes/scripts/create.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
  sh ./Provision/Nodes/scripts/storeNodesIps.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
	sh ./Provision/Rancher/scripts/deploy/startRancherDocker.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
	sh ./Provision/Rancher/scripts/deploy/checkRunning.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
	sh ./Provision/Rancher/scripts/deploy/defaultConfig.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
	sh ./Provision/Rancher/scripts/deploy/setWorkers.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
	sh ./Provision/Rancher/scripts/deploy/waitClusterDeployed.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
  sh ./Provision/Rancher/scripts/deploy/createStorage.sh
  if [ $? -ne 0 ]; then
    exit 1
  fi
