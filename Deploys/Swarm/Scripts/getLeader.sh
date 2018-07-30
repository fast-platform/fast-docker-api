RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
    echo "$BLUE INFO - $NC Getting IP of the manager node"
    manager_ip=$(vagrant ssh fs-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
    worker_token=$(vagrant ssh fs-1 -c "docker swarm join-token worker -q")
    echo "$GREEN OK - $NC Manager IP: $manager_ip"
    echo "$GREEN OK - $NC Worker token: $worker_token $NC"

         
    

    

