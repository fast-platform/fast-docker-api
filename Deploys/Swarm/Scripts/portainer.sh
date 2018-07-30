echo "Deploying portainer"

vagrant ssh fs-1 -c "docker volume create portainer_data"
vagrant ssh fs-1 -c "docker service create --name portainer --publish 9000:9000 --replicas=1 --constraint 'node.role == manager' --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock --mount type=volume,src=portainer_data,dst=/data portainer/portainer -H unix:///var/run/docker.sock"
