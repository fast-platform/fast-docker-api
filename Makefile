deploy-compose:
	sh ./Deploys/Compose/Scripts/index.sh
deploy-swarm:
	sh ./Deploys/Swarm/Scripts/index.sh
destroy:
	cd ./Deploys/Compose && docker-compose down
	rm -rf ./data