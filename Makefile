up:
	sh ./Provision/index.sh
ssh:
	vagrant ssh FAST-RANCHER-1
off:
	sh ./Provision/Nodes/scripts/suspend.sh
on:
	sh ./Provision/Nodes/scripts/resume.sh
ip:
	cat ./Provision/Nodes/ips.yaml
backup:
	sh ./Provision/Rancher/scripts/backup.sh
restore:
	sh ./Provision/Rancher/scripts/restoreBackUp.sh
add-node:
	sh ./Provision/Nodes/scripts/createSingleNode.sh
down:
	cd ./Deploys/Compose && docker-compose down
	rm -rf ./data
destroy:
	sh ./Provision/Nodes/scripts/destroy.sh
clean-docker:
	docker volume rm $(docker volume ls -qf dangling=true)
	docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
	docker rm -f $(docker ps -a -q)
	docker rmi $(docker images --filter "dangling=true" -q --no-trunc)