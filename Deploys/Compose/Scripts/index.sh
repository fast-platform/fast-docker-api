
source "$(dirname $0)/common.sh"

cd Deploys/Compose && docker-compose up -d kong-database

echo "Waiting for Database to be up...30segs"
 sleep 30
docker-compose up kong-migrations 
echo "Waiting for the migrations to be ready...5segs"
  sleep 5 
docker-compose up -d kong konga
 sleep 3
docker-compose up -d mongo 
sleep 3
docker-compose up -d formio opencpu portainer ironfunctions ironfunctionsui prometheus netdata grafana


sh ./Scripts/kong_services.sh
sleep 20
docker-compose up mongo_exporter