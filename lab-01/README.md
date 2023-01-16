# Lab 01

## Ambiente de densevolvimento
   - Estou utilizando ubuntu 22.04 LTS e Virtualbox como Hipervisor.

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


- config.vm.box = "ubuntu/bionic64"
    - define a boxe que utilizei.  
`
No arquivo estou provisionando as duas VM's de uma vez então os comando são bem semelhantes. Vou citar a VM do servidor de containers e o por comparação, pode ser entendido o codigo referente a VM do servidor de proxy.
`

- config.vm.define "docker" do |docker|
    - docker.vm.hostname = "docker"  
`
Cria a VM docker e da o nome para o host.
`

- docker.vm.network "private_network", ip: "192.168.56.10"  
`
Cria uma rede privada e força o ip fixo 192.168.56.10 para a maquina.
tive que trabalhar na rede 192.168.56.0/24 por conta do range disponibilizado por padrão no virtualbox.
`

- docker.vm.provision "shell", path: "docker.sh"  
`
Executa o script shell docker.sh
`

- docker.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"   
`
Envia minha chave ssh publica para a Vm para que possa ser acessado via terminal posteriormente.
Para que este comando funcione, deve ser criado um par de chaves ssh na home de seu Ubuntu, com o comando "sudo ssh-keygen"
`

- 02 - SHELL SCRIPT: docker.sh:

```
#!/bin/bash

apt-get update
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
docker run --name wordpress -p 8080:80 -d wordpress
iptables -A INPUT -s 192.168.56.11 -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j DROP
```

`
O script realiza a atualização do apt-get, instala o docker, consecutivamente inicia o docker e o deixa ativo.  
Após isto sobe um container de wordpress com o redirecionamento de porta 8080 da VM para a porta 80 do container.
Após isto o mesmo adiciona regras para aceitar apenas conexão do ip 192.168.56.11 na porta 8080, qualquer conexão de outro ip, deve ser descartado.
`

- 03 - SHELL SCRIPT: proxy.sh:

```
#!/bin/bash

apt-get update
apt-get install -y nginx

cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://192.168.56.10:8080;
        
    }
}
EOF

systemctl restart nginx
```
`
O script realiza a atualização do apt-get, instala o nginx, para servir com servidor de proxy reverso.    
Na linha que começa com o comando cat, o script adiciona o bloco "server" no arquivo default de sites disponiveis do nginx.
Após isto o serviço é reiniciado. 
`

No bloco server, é configurado o proxy, o nginx fica escutando na sua porta 80 e redireciona a requisição para o endereço configurado em proxy_pass.
