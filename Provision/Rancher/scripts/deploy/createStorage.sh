source ./Provision/Common/index.sh
nodeIP="${machinePrefix}_RANCHER_1"
get_env RANCHER_ADMIN_PASSWORD

vagrant ssh ${machinePrefix}-RANCHER-1 -c '
  LOGINRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3-public/localProviders/local?action=login \
    --header "Content-Type: application/json" \
    --data-binary '"'"'{"username":"admin","password":"'"${RANCHER_ADMIN_PASSWORD}"'"}'"'"' \
    --request POST) && \

    LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token) && \

  CLUSTERRESPONSE=$(curl --insecure \
    -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/clusters?name=fast \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $LOGINTOKEN" \
    --request GET) && \

  CLUSTERID=$(echo $CLUSTERRESPONSE | jq -r '"'"'.data[] | select(.name == "fast") | .id'"'"') && \

  PROJECTRESPONSE=$(curl --insecure \
  -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/project \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $LOGINTOKEN" \
  --data-binary '"'"'{"type":"project","name":"'"${machinePrefix}"'","podSecurityPolicyTemplateId":"unrestricted","clusterId":"'"'"'$CLUSTERID'"'"'"}'"'"' \
  --request POST) && \

  PROJECTID=$(echo $PROJECTRESPONSE | jq -r .id) && \
 
  PROJECTRESPONSE=$(curl --insecure \
  -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/clusters/$CLUSTERID/namespace \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $LOGINTOKEN" \
  --data-binary '"'"'{"type":"namespace","name":"longhorn-system", "projectId":"'"'"'$PROJECTID'"'"'"}'"'"' \
  --request POST) && \

  echo $PROJECTRESPONSE

  LONGHORNRESPONSE=$(curl --insecure \
  -s https://'"${!nodeIP}"':'"${RANCHER_https_port}"'/v3/projects/$PROJECTID/app \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $LOGINTOKEN" \
  --data-binary '"'"'{"prune":false,"type":"app","name":"longhorn","answers":{"driver":"csi","persistence.flexvolumePath":"/var/lib/kubelet/volumeplugins","persistence.defaultClass":"true","ingress.enabled":"true","ingress.host":"xip.io","service.ui.type":"NodePort","service.ui.nodePort":""},"targetNamespace":"longhorn-system","externalId":"catalog://?catalog=library&template=longhorn&version=0.3.0","projectId":"'"'"'$PROJECTID'"'"'"}'"'"' \
  --request POST) && \

  echo $LONGHORNRESPONSE
'