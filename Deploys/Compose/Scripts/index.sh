
source "$(dirname $0)/common.sh"

cd Deploys/Compose && docker-compose up -d kong-database

echo "Waiting for Database to be up...30segs"
 sleep 30
docker-compose up kong-migrations 
echo "Waiting for the migrations to be ready...5segs"
  sleep 5 
docker-compose up -d kong konga
 sleep 3

docker-compose up -d formio opencpu portainer netdata

sh ./Scripts/kong_services.sh