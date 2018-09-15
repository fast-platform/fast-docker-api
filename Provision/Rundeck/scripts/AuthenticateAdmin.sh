RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

manager_ip=$(vagrant ssh FAST-SERVER-1 -c "ifconfig eth1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1")
manager_ip="$(echo "${manager_ip}" | tr -d '[:space:]')"

echo "$BLUE INFO - $NC Authenticating Rundeck Admin"
vagrant ssh FAST-SERVER-1 -c 'curl --cookie-jar /tmp/rundeck_cookies.txt --form j_password=admin --form j_username=admin http://'"${manager_ip}"':4440/j_security_check'

if [ -f /tmp/rundeck_cookies.txt ]; then
    echo "$BLUE INFO - $NC User was not authenticated, retrying"
fi

echo "$GREEN OK - $NC Rundeck admin Authenticated $NC"