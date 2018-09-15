source ./Provision/Common/index.sh

createMachines=no


step "Checking if VirtualBox is installed"

command -v VBoxManage >/dev/null 2>&1 || { 
    echo >&2 "$RED ERROR $NC - 'VirtualBox' is not installed on this host, please install it.  Aborting."; 
    exit 1; 
}

success "VBoxManage is installed"

sh ./Provision/Nodes/scripts/checkRequirements.sh
if [ $? -ne 0 ]; then
    exit 1
fi

command vagrant status $machinePrefix-RANCHER-1 | grep 'not created (virtualbox)' &> /dev/null 
if [ $? == 0 ]; then
    createMachines=yes
fi 

if [ "$createMachines" == "no" ] ; then
	success "All machines are already running"
elif [ "$createMachines" == "yes" ]; then
    info "Creating machines to start the cluster, this takes a couple minutes"
    vagrant up  
fi