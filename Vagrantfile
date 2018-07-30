# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Amount of nodes to start
  nodes = 2
  (1..nodes).each do |i|
    config.vm.network "private_network", type: "dhcp"
    # Set the base image
    config.vm.box = "kwilczynski/ubuntu-16.04-docker"
    # Give names to the nodes
    config.vm.define "fs-#{i}" do |node|
      # Set the current $PWD as the place where you will
      # store the VMDKs that are attached to the VM.
      file_to_disk = "#{ENV['PWD']}/data/drives/fs-#{i}.vdi"
      # Add a SATA controlle with 30 ports to the VM, so REX-Ray can add disks on the fly
      node.vm.provider :virtualbox do |vb|
        vb.name = "fs-#{i}"
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--memory", "2548"]
        # enable serial port just in case vagrant image does not
        vb.customize ["modifyvm", :id, "--uart1", "0x3F8", 4]
        unless File.exist?(file_to_disk)
         vb.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 5048]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        vb.customize ["modifyvm", :id, "--macaddress1", "auto"]
        vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
      end
      
      # provision the machines
      node.vm.provision "shell", inline: <<-SHELL
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      BLUE='\033[0;34m'
      NC='\033[0m' # No Color
       echo "Machine booted!"
       echo "$BLUE INFO - $NC Removing live-restore from nodes"
       sudo apt-get update 
       sudo apt-get install jq -y
       sudo apt-get install systemd
       sudo jq -c '."live-restore"=false' /etc/docker/daemon.json > /etc/docker/daemon2.json
       sudo mv /etc/docker/daemon.json /etc/docker/daemon_original.json && sudo mv /etc/docker/daemon2.json /etc/docker/daemon.json
       sudo systemctl restart docker
       sudo iptables -A INPUT -p tcp --dport 2376 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 2376 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 2377 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 2377 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 7946 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 7946 -j ACCEPT
       sudo iptables -A INPUT -p udp --dport 7946 -j ACCEPT
       sudo iptables -A OUTPUT -p udp --dport 7946 -j ACCEPT
       sudo iptables -A INPUT -p udp --dport 4789 -j ACCEPT
       sudo iptables -A OUTPUT -p udp --dport 4789 -j ACCEPT
       SHELL
       if i == 1
        node.vm.provision "shell", inline: <<-SHELL
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[1;33m'
        BLUE='\033[0;34m'
        NC='\033[0m' # No Color
          echo "$BLUE INFO - $NC Creating Swarm Leader: FS-1"
          manager_ip=$(ifconfig eth1 | grep 'inet addr' | cut -d ':' -f 2 | cut -d ' ' -f 1)
          docker swarm init --advertise-addr ${manager_ip}
          echo "$GREEN OK - $NC Swarm node FS-1 is now the leader $NC"
       SHELL
       end
  end
  end

end