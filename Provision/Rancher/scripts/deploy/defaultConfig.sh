source ./Provision/Common/index.sh

get_env RANCHER_ADMIN_PASSWORD

if [ $RANCHER_count == 1 ]; then

  nodeIP="${machinePrefix}_RANCHER_1"
  server_url="https://${!nodeIP}:${RANCHER_https_port}"

  info "Seeding default configuration"
  vagrant ssh ${machinePrefix}-RANCHER-1 -c '

    LOGINRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3-public/localProviders/local?action=login \
    --header "Content-Type: application/json" \
    --data-binary '"'"'{"username":"admin","password":"admin"}'"'"' \
    --request POST) && \

    LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token) && \
    echo $LOGINTOKEN && \

    curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/users?action=changepassword \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '"'"'{"currentPassword":"admin","newPassword":"'"${RANCHER_ADMIN_PASSWORD}"'"}'"'"' \
    --request POST && \

    APIRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/token \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '"'"'{"type":"token","description":"automation", "name": "" }'"'"' \
    --request POST) && \

    APITOKEN=$(echo $APIRESPONSE | jq -r .token) && \
    SERVERURLRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/settings/server-url \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '"'"'{"name":"server-url","value":"'"${server_url}"'"}'"'"' \
    --request PUT) && \
    echo $SERVERURLRESPONSE && \

    CLUSTERRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/cluster \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --data "@/vagrant/Provision/Rancher/scripts/deploy/resources/clusterInfo.json" \
    --request POST) && \

    echo $CLUSTERRESPONSE && \

    CLUSTERID=$(echo $CLUSTERRESPONSE | jq -r .id) && \

    echo $CLUSTERID && \

    CLUSTERGETOKENRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/clusterregistrationtoken \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '"'"'{"type":"clusterRegistrationToken","clusterId":"'"'"'$CLUSTERID'"'"'"}'"'"' \
    --request POST) && \


    NODECOMMAND=$(echo $CLUSTERGETOKENRESPONSE | jq -r .nodeCommand) && \
    NODECOMMAND="$NODECOMMAND --etcd --controlplane --worker"

    echo " "
    echo " "
    echo "####################################"
    echo " "
    echo $NODECOMMAND
    echo " "
    echo "####################################"
    echo " "
    echo " "
  '
  success "Cluster configured!"
  #eval $NODECOMMAND
else
  error "We have not implemented multi-node Rancher deployment...coming soon"
fi 

  