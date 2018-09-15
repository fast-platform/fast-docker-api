source ./Provision/Common/index.sh

timestamp=$(date +%s)
version='latest'

echo "$YELLOW INFO Creating backup at $timestamp"
echo "$BLUE INFO - $NC Stoping rancher"
vagrant ssh FAST-SERVER-1 -c  'docker stop fast_rancher'
echo "$BLUE INFO - $NC Creating Volume"
vagrant ssh FAST-SERVER-1 -c  'docker create --volumes-from fast_rancher --name rancher-data-'"${timestamp}"' rancher/rancher:'"${version}"''
echo "$BLUE INFO - $NC Creating Backup"
vagrant ssh FAST-SERVER-1 -c  'docker run  --volumes-from rancher-data-'"${timestamp}"' -v /vagrant/data/Rancher/backup:/backup alpine tar zcvf /backup/rancher-data-backup-'"${version}"'-'"${timestamp}"'.tar.gz /var/lib/rancher'
echo "$BLUE INFO - $NC Restart rancher"
vagrant ssh FAST-SERVER-1 -c  'docker start fast_rancher'