RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

manager_ip=$(vagrant ssh FAST-SERVER-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"

echo "$BLUE INFO - $NC Creating Resource File Configuration"

vagrant ssh FAST-SERVER-1 -c 'rm -f /var/rundeck/projects/FAST_HOST_MANAGEMENT/etc/project.properties && docker cp /vagrant/Provision/scripts/project.properties services_rundeck_1:/var/rundeck/projects/FAST_HOST_MANAGEMENT/etc/project.properties'

echo "$GREEN OK - $NC Rundeck config file created $NC"

echo "$BLUE INFO - $NC Copying resouce.xml"
vagrant ssh FAST-SERVER-1 -c 'xmlstarlet ed --inplace -u "project/node/@hostname" -v '"${manager_ip}"' /vagrant/Provision/scripts/resource.xml &&  docker cp /vagrant/Provision/scripts/resource.xml services_rundeck_1:/var/rundeck/resource.xml && docker exec -ti services_rundeck_1 sh -c "chmod -R 0777 /var/rundeck/resource.xml"'
echo "$GREEN OK - $NC Resources Imported $NC"