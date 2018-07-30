#while getopts e:d:p:f: option
while getopts e:o: option
do
case "${option}"
in
e) ENV=${OPTARG};;
o) ORC=${OPTARG};;
esac
done

if [ "$ENV" == "dev" ] && [ "$ORC" == "swarm" ]; then
	echo "Deploying app with docker swarm";
  sh ./Deploys/Swarm/Scripts/index.sh
elif [ "$ENV" == "dev" ] && [ "$ORC" == "compose" ]; then
	echo "Deployinh app with docker compose"
  cd Deploys/Compose && docker-compose up -d mongo formio portainer opencpu netdata
fi
#sh ./deploys/dev.sh