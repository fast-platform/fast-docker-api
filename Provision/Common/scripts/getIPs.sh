#!/bin/bash
source "./Provision/Common/scripts/yamlLoader.sh"

if [ -f ./Provision/Nodes/ips.yaml ]; then
  create_variables "./Provision/Nodes/ips.yaml"
fi