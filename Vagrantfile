# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.box = "bento/ubuntu-20.04"
    master.vm.network "private_network", ip: "192.168.33.49"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end

  # Master provisioner block with an external script
  #master.vm.provision "shell", path: "test.sh", args => "'first arg' second", env: {"DEBIAN_FRONTEND" => "noninteractive"}, privileged: false, run: "always"

  #master.vm.provision "shell", path: "/execute.sh", args: "'emma' emma90", env: {"DEBIAN_FRONTEND" => "noninteractive"}, privileged: false, run: "always"
  master.vm.provision "shell", path: "execute.sh", env: {"DEBIAN_FRONTEND" => "noninteractive"}, privileged: true, run: "always"

  end

  config.vm.define "slave" do |slave|
    slave.vm.hostname = "slave-node"
    slave.vm.box = "bento/ubuntu-20.04"
    slave.vm.network "private_network", ip: "192.168.33.50"
    slave.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
  end
end