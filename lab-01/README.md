# Lab 01

## Ambiente de densevolvimento
   Estou utilizando ubuntu 22.04 lts e virtualbox como hipervisor.
   Utilizei o Vagrant para automatizar a criação das VM's e SHELL SCRIPTS para configurar as maquinas.


- 01 - O lab deve conter duas Instâncias/VMs;
   - VM-01 servidor de contêineres
   - VM-02 servidor proxy

   - Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.define "docker" do |docker|
    docker.vm.hostname = "docker"
    docker.vm.network "private_network", ip: "192.168.56.10"
    docker.vm.provision "shell", path: "docker.sh"
    docker.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub" 
  end

  config.vm.define "proxy" do |proxy|
    proxy.vm.hostname = "proxy"
    proxy.vm.network "private_network", ip: "192.168.56.11"
    proxy.vm.provision "shell", path: "proxy.sh"
    proxy.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub" 
  end
end
```


- 02 - Usando contêineres para disponibilizar uma aplicação web;
- 03 - Usando proxy para dar acesso a aplicação web do item 02;
- 04 - Os itens 02 e 03 devem ser automatizado na criação do ambiente;

## Objetivo 2
- Documentar o processo requerido para provisionamento do ambiente criado.

## Tecnologias sugeridas
- Vagrant
- Libvirt 
- Docker
- Nginx
- Shell Script.

## Diferencial
- Organização de código
- Ansible
