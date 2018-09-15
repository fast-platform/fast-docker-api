sudo apt-get install git -y
git clone https://github.com/UN-FAO/fast-docker-api.git
#Install docker
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
#Install docker-compose

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Install make
sudo apt-get install make