RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#We should create the project only if it doesnt previously exist

manager_ip=$(vagrant ssh FAST-SERVER-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"

echo "$BLUE INFO - $NC Creating FAST Rundeck Project"

vagrant ssh FAST-SERVER-1 -c 'curl --header "Content-Type: application/json" --header "Accept: application/json" --request POST -b /tmp/rundeck_cookies.txt --data "@/vagrant/Provision/scripts/project.json" http://'"${manager_ip}"':4440/api/25/projects'

echo "$GREEN OK - $NC Rundeck admin Authenticated $NC"