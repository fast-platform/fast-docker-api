
source "$(dirname $0)/common.sh"

cd Deploys/Compose && docker-compose up -d kong-database
# TODO we have to replace this waits by wait-for-it.js!!
echo "Waiting for Database to be up...30segs"
 sleep 25
docker-compose up kong-migrations 

docker-compose up -d kong konga mongo formio opencpu portainer ironfunctions ironfunctionsui prometheus netdata grafana mailhog mongo_exporter kong-database_exporter
sleep 6
sh ./Scripts/kong_services.sh