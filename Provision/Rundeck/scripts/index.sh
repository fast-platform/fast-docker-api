RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "$BLUE INFO - $NC Starting Rundeck"
manager_ip=$(vagrant ssh FAST-SERVER-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"

vagrant ssh FAST-SERVER-1 -c 'sed -i "s/.*RUNDECK_EXTERNAL_SERVER_URL=.*/ RUNDECK_EXTERNAL_SERVER_URL=http:\/\/'"${manager_ip}"':4440/" /vagrant/Services/.env' 
# Create Rundeck Instance
vagrant ssh FAST-SERVER-1 -c 'cd /vagrant/Services && docker-compose up -d rundeck'
# Get manager IP
manager_ip=$(vagrant ssh FAST-SERVER-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"

#Wait for Rundeck to be Up
vagrant ssh FAST-SERVER-1 -c 'until $(curl --output /dev/null --silent --head --fail http://'"${manager_ip}"':4440); do  printf . ; sleep 3; done'
echo "$GREEN OK - $NC Rundeck is UP and Running $NC"

sh $(dirname $0)/AuthenticateAdmin.sh && sh $(dirname $0)/createProject.sh && sh $(dirname $0)/createPasswordKey.sh && sh $(dirname $0)/createResourceFile.sh