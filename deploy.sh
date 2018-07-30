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
	echo "Deploying app with docker compose"
  sh ./Deploys/Compose/Scripts/index.sh
fi
#sh ./deploys/dev.sh