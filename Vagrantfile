# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
x = YAML.load_file('./nodesConfig.yaml')
# Amount of nodes to start
nodes = Integer(x.fetch('RANCHER').fetch('count')) + Integer(x.fetch('WORKER').fetch('count')) + Integer(x.fetch('LOADBALANCER').fetch('count'))
if x.fetch('singleNodeDeploy') == true
  nodes = 1
end
machinePrefix = x.fetch('machinePrefix')

if ENV['type'] == 'singleNode'
  nodes=1
end



Vagrant.configure("2") do |config|

  (1..nodes).each do |i|
    nodeNumber = 0
    if i > Integer(x.fetch('RANCHER').fetch('count')) + Integer(x.fetch('WORKER').fetch('count'))
     nodeType= "LOADBALANCER"
     nodeNumber = 1
    elsif i > x.fetch('RANCHER').fetch('count')
      nodeType= "WORKER"
      nodeNumber = i - Integer(x.fetch('RANCHER').fetch('count'))
    else
      nodeType= "RANCHER"
      nodeNumber = i
    end

    if ENV['type'] == 'singleNode'
      nodeType= "WORKER"
      nodeNumber= Integer(x.fetch('WORKER').fetch('count')) + 1
    end

    config.vm.network "private_network", type: "dhcp"
    # Set the base image
    config.vm.box = "cabrerabywaters/fast-ubuntu16.04"
    config.vm.box_version = "0.1"
    nodeHostName = "#{machinePrefix}#{nodeType}#{nodeNumber}".downcase
    # Give names to the nodes
    config.vm.define "#{machinePrefix}-#{nodeType}-#{nodeNumber}" do |node|
      # Set the current $PWD as the place where you will
      # store the VMDKs that are attached to the VM.
      file_to_disk = "#{ENV['PWD']}/data/drives/#{machinePrefix}-#{nodeType}-#{nodeNumber}.vdi"
      # Add a SATA controlle with 30 ports to the VM, so REX-Ray can add disks on the fly
      node.vm.provider :virtualbox do |vb|
        vb.name = "#{machinePrefix}-#{nodeType}-#{nodeNumber}"
        vb.customize ["modifyvm", :id, "--cpus", x.fetch(nodeType).fetch('cpus')]
        vb.customize ["modifyvm", :id, "--memory", x.fetch(nodeType).fetch('memory')]
        # enable serial port just in case vagrant image does not
        vb.customize ["modifyvm", :id, "--uart1", "0x3F8", 4]
        unless File.exist?(file_to_disk)
         vb.customize ['createhd', '--filename', file_to_disk, '--size', x.fetch(nodeType).fetch('diskSize')]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        vb.customize ["modifyvm", :id, "--macaddress1", "auto"]
        vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
      end
      
      config.vm.provision :shell, :path => "./Provision/Nodes/scripts/provisionScript.sh", :args => "#{nodeHostName}"
  end
  end

end