RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#We should create the project only if it doesnt previously exist

manager_ip=$(vagrant ssh FAST-SERVER-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"

echo "$BLUE INFO - $NC Creating Rundeck key for Manager Node"

vagrant ssh FAST-SERVER-1 -c 'sed -i "s/.*RUNDECK_CLI_RD_URL=.*/ RUNDECK_CLI_RD_URL=http:\/\/'"${manager_ip}"':4440/" /vagrant/Services/.env'      
vagrant ssh FAST-SERVER-1 -c 'cd /vagrant/Services && docker-compose up -d rundeck-cli'
vagrant ssh FAST-SERVER-1 -c 'docker exec -ti services_rundeck-cli_1 sh -c "echo "vagrant" >/tmp/password && rd keys create --type password --path keys/FAST/FAST-SERVER-MANGER --file /tmp/password"'
vagrant ssh FAST-SERVER-1 -c 'docker rm -f services_rundeck-cli_1'

echo "$GREEN OK - $NC Rundeck key created $NC"