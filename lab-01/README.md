# Lab 01

## Ambiente de densevolvimento
   - Estou utilizando ubuntu 22.04 lts e virtualbox como hipervisor.

   - Utilizei o Vagrant para automatizar a criação das VM's e SHELL SCRIPTS para configurar as maquinas.


- 01 - Vagrantfile para o provisionamento das 2 VM's;
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


- - config.vm.box = "ubuntu/bionic64"
    - define a boxe que utilizei.  
`
No arquivo estou provisionando as duas VM's de uma vez então os comando são bem semelhantes. Vou citar a VM do servidor de containers e o por comparação, pode ser entendido o codigo referente a VM do servidor de proxy.
`

- - config.vm.define "docker" do |docker|
    - docker.vm.hostname = "docker"  
`
Cria a VM docker e da o nome para o host.
`

- - docker.vm.network "private_network", ip: "192.168.56.10"  
`
Cria uma rede privada e força o ip fixo 192.168.56.10 para a maquina.
tive que trabalhar na rede 192.168.56.0/24 por conta do range disponibilizado por padrão no virtualbox.
`

- - docker.vm.provision "shell", path: "docker.sh"  
`
Executa o script shell docker.sh
`

- - docker.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"   
`
Envia minha chave ssh publica para a Vm para que possa ser acessado via terminal posteriormente.
Para que este comando funcione, deve ser criado um par de chaves ssh na home de seu Ubuntu, com o comando "sudo ssh-keygen"
`
