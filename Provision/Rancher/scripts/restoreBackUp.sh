source ./Provision/Common/index.sh

timestamp=1536158768
version='latest'

echo "$YELLOW INFO Restoring from $timestamp"
echo "$BLUE INFO - $NC Stoping rancher"
vagrant ssh FAST-SERVER-1 -c  'docker stop fast_rancher'
echo "$BLUE INFO - $NC Mounting previous volume"
vagrant ssh FAST-SERVER-1 -c  'docker run  --volumes-from fast_rancher \
  -v /vagrant/data/Rancher/backup:/backup \
  alpine sh -c "rm /var/lib/rancher/* -rf  && \
  tar zxvf /backup/rancher-data-backup-'"${version}"'-'"${timestamp}"'.tar.gz"'
echo "$BLUE INFO - $NC Restart rancher"
vagrant ssh FAST-SERVER-1 -c  'docker start fast_rancher'