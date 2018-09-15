source ./Provision/Common/index.sh

password="password"
vagrant ssh FAST-SERVER-1 -c '
  LOGINRESPONSE=$(curl --insecure \
    -s https://'"${manager_ip}"':8443/v3-public/localProviders/local?action=login \
    --header "Content-Type: application/json" \
    --data-binary '"'"'{"username":"admin","password":"'"${password}"'"}'"'"' \
    --request POST) && \

    LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token) && \

  CLUSTERRESPONSE=$(curl --insecure \
    -s https://'"${manager_ip}"':8443/v3/clusters?name=fast \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --request GET) && \

  CLUSTERID=$(echo $CLUSTERRESPONSE | jq -r '"'"'.data[] | select(.name == "fast") | .id'"'"') && \

  CLUSTERRESPONSE=$(curl --insecure \
  -s https://'"${manager_ip}"':8443/v3/clusters/$CLUSTERID/storageclass \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $LOGINTOKEN" \
  --data "@/vagrant/Provision/Rancher/scripts/deploy/resources/storageClass.json" \
  --request POST) && \
  echo $CLUSTERRESPONSE
'