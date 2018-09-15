source ./Provision/Common/index.sh

step "Checking if VirtualBox is installed"

command -v VBoxManage >/dev/null 2>&1 || { 
    echo >&2 "$RED ERROR $NC - 'VirtualBox' is not installed on this host, please install it.  Aborting."; 
    exit 1; 
}

success "VBoxManage is installed"

info "Creating machines to start the cluster, this takes a couple minutes"
  type="singleNode" vagrant up  