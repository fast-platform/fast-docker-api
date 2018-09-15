source ./Provision/Common/index.sh

nodeIP="${machinePrefix}_RANCHER_1"
server_url="https://${!nodeIP}:${RANCHER_https_port}"
get_env RANCHER_ADMIN_PASSWORD

info "Setting Rancher Workers"
nodeType="WORKER"
nodeCount=$WORKER_count

if [ "$singleNodeDeploy" == "true" ]; then
  nodeType="RANCHER"
  nodeCount=$RANCHER_count
fi

for ((i=1;i<=$nodeCount;i++)); do 
  nodeNumber=0

  if [ "$RANCHER_isNode" == "false" ] ; then
    nodeType="WORKER"
    nodeNumber=${i}
  elif [ "$RANCHER_isNode" == "true" ] && [ "$i" -gt "$RANCHER_count" ] ; then
    nodeType="WORKER"
    nodeNumber=$(( ${i} - $RANCHER_count )) 
  else
    nodeType="RANCHER"
    nodeNumber=${i}
  fi

  workerIP="${machinePrefix}_${nodeType}_$nodeNumber"
  workerIP=${!workerIP}
  workerMachineName="${machinePrefix}-${nodeType}-$nodeNumber"

  info "Configuring node: $workerIP $workerMachineName"

  vagrant ssh $workerMachineName -c '

    LOGINRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3-public/localProviders/local?action=login \
    --header "Content-Type: application/json" \
    --data-binary '"'"'{"username":"admin","password":"'"${RANCHER_ADMIN_PASSWORD}"'"}'"'"' \
    --request POST) && \

    LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token) && \
    echo $LOGINTOKEN && \

    while true; do
      ENV_STATE=$(curl --insecure \
      -sLk https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/cluster?name=fast \
      --header "Authorization: Bearer $LOGINTOKEN" \
      --header "Content-Type: application/json" \
      --request GET  | jq -r '"'"'.data[] | select(.name == "fast") | .id'"'"')

      if [[ "$ENV_STATE" != "null" ]]; then
        echo "Cluster is ready to be deployed"
        break
      else
        echo "Waiting for initial cluster config"
        sleep 5
      fi
    done


    CLUSTERID=$(curl --insecure \
      -sLk https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/cluster?name=fast \
      --header "Authorization: Bearer $LOGINTOKEN" \
      --header "Content-Type: application/json" \
      --request GET  | jq -r '"'"'.data[] | select(.name == "fast") | .id'"'"')

    CLUSTERREGTOKEN=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/clusterregistrationtoken?id='"'"'$CLUSTERID'"'"' \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --request GET) && \

    NODECOMMAND=$(echo $CLUSTERREGTOKEN | jq -r '"'"'.data[].nodeCommand'"'"') && \

    if [ "'"${i}"'" == "1" ] || [ "'"${i}"'" == "1" ]; then
      NODECOMMAND="$NODECOMMAND --etcd --controlplane --worker --internal-address '"${workerIP}"' --address '"${workerIP}"'"
    else
      NODECOMMAND="$NODECOMMAND --worker --internal-address '"${workerIP}"' --address '"${workerIP}"'"
    fi
    
    echo $NODECOMMAND
    eval $NODECOMMAND
  '

done






