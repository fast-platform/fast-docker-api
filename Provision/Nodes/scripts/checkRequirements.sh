source ./Provision/Common/index.sh
meetRequiremets=1
configFileName="nodesConfig.yaml"
minimumRancherCPU=2
minimumRancherNodes=1
minimumRancherRAM=1000
singleNodeMinimumRAM=3000
singleNodeMinimumCPUs=4

step "Checking node config file $configFileName"

info "Checking deployment info"

if [ -z ${singleNodeDeploy+x} ]; then 
  error "'deployment' configuration is unset. Check your $configFileName file."
  meetRequiremets=0
else
  if [ "$singleNodeDeploy" == "true" ] || [ "$singleNodeDeploy" == "false"  ] ; then
  success "Deployment infomation is OK"
  else
    error "In the nodesConfig.yaml file, 'deployment' must be either 'true' or 'false'. You wrote '$singleNodeDeploy'"
    meetRequiremets=0
  fi
fi

info "Checking number of Rancher nodes"

if [ -z ${RANCHER_count+x} ]; then 
  error "RANCHER 'count' configuration is unset. Check your $configFileName file."
  meetRequiremets=0
else
  if [ "$RANCHER_count" -ge "$minimumRancherNodes" ] ; then
  success "Number of Rancher nodes meets requirements"
  else
    error "The Rancher node must have at least $minimumRancherNodes CPUs assigned. You assigned $RANCHER_count"
    meetRequiremets=0
  fi
fi


info "Checking Rancher provisioned CPU"

if [ -z ${RANCHER_cpus+x} ]; then 
  error "RANCHER 'cpus' configuration is unset. Check your $configFileName file."
  meetRequiremets=0
else
  if [ "$RANCHER_cpus" -ge "$minimumRancherCPU" ] ; then
  success "Rancher CPU meets requirements"
  else
    error "The Rancher node must have at least $minimumRancherCPU CPUs assigned. You assigned $RANCHER_cpus"
    meetRequiremets=0
  fi
fi

if [ -z ${RANCHER_memory+x} ]; then 
  error "RANCHER 'memory' configuration is unset. Check your $configFileName file."
  meetRequiremets=0
else
  info "Checking provisioned RAM"
  if [ "$RANCHER_memory" -ge "$minimumRancherRAM" ] ; then
    success "Rancher RAM meets requirements"
  else
    error "The Rancher node must have at least $minimumRancherRAM MB of RAM memory assigned. You assigned $RANCHER_memory"
    meetRequiremets=0
  fi
fi



if [ "$singleNodeDeploy" == "true" ]; then


  if [ "$RANCHER_cpus" -ge "$singleNodeMinimumCPUs" ] ; then
    success "Rancher RAM meets requirements"
  else
    error "The Rancher node must have at least $singleNodeMinimumCPUs CPUs in single node Mode. You assigned $RANCHER_memory"
    meetRequiremets=0
  fi

  if [ "$RANCHER_memory" -ge "$singleNodeMinimumRAM" ] ; then
    success "Rancher RAM meets requirements"
  else
    error "The Rancher node must have at least $singleNodeMinimumRAM MB of RAM memory assigned in single node Mode. You assigned $RANCHER_memory"
    meetRequiremets=0
  fi


  if [ "$RANCHER_http_port" -ne "80" ] ; then
    success "Rancher RAM meets requirements"
  else
    error "The Rancher http port must be different from 80. You seted it to $RANCHER_http_port"
    meetRequiremets=0
  fi


  if [ "$RANCHER_https_port" -ne "443" ] ; then
    success "Rancher RAM meets requirements"
  else
    error "The Rancher http port must be different from 443. You seted it to $RANCHER_https_port"
    meetRequiremets=0
  fi


fi


if [ $meetRequiremets == 0 ] ; then
  error "The configuration file has problems. Exiting installation"
  exit 1
else
  success "Node Config file, $configFileName OK"
fi