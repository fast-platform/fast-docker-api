source ./Provision/Common/index.sh

info "Deploying Rancher containers"

if [ $RANCHER_count == 1 ]; then
    vagrant ssh ${machinePrefix}-RANCHER-1 -c '
    if [ ! "$(docker ps -q -f name='"${machinePrefix}"'_rancher)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name='"${machinePrefix}"'_rancher)" ]; then
        docker rm '"${machinePrefix}"'_rancher
    fi
    # run your container
       docker run -d --restart=unless-stopped \
      -p '"${RANCHER_http_port}"':80 -p '"${RANCHER_https_port}"':443 \
      --name '"${machinePrefix}"'_rancher \
      rancher/rancher:latest
    else
      echo "Docker container '"${machinePrefix}"'_rancher  was already up!"
    fi
  '
  if [ $? -ne 0 ]; then
    error "Could not start Docker container on Rancher Machine ${machinePrefix}-RANCHER-1"
    exit 1
  fi
else
  error "We have not implemented multi-node Rancher deployment...coming soon"
  exit 1
fi 





       \
       \
      