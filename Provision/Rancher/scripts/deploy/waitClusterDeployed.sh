source ./Provision/Common/index.sh

nodeIP="${machinePrefix}_RANCHER_1"
server_url="https://${!nodeIP}:${RANCHER_https_port}"
get_env RANCHER_ADMIN_PASSWORD

vagrant ssh ${machinePrefix}-RANCHER-1 -c '
  LOGINRESPONSE=$(curl --insecure \
    -s '"${server_url}"'/v3-public/localProviders/local?action=login \
    --header "Content-Type: application/json" \
    --data-binary '"'"'{"username":"admin","password":"'"${RANCHER_ADMIN_PASSWORD}"'"}'"'"' \
    --request POST) && \

    LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token) && \

  STATE="none" && \
  until [ "$STATE" = "active" ]; do \
  CLUSTERRESPONSE=$(curl --insecure \
    -s '"${server_url}"'/v3/clusters?name=fast \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --request GET) && \

  STATE=$(echo $CLUSTERRESPONSE | jq -r '"'"'.data[] | select(.name == "fast") | .state'"'"') && \
    echo "Current status: $STATE" && \
    echo "Waiting 20 more seconds" && \
    sleep 20 \
  ; done
'