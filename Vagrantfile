# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.hostname = "hw14-pam"
  
    config.vm.box = "centos/7"
    config.vm.box_check_update = false
    config.vm.provision "shell", name: "Script prepare lab for demo PAM", path: "script.sh"
  
  end
