# Lab 02

## Ambiente de densevolvimento
   - Estou utilizando ubuntu 22.04 LTS e Virtualbox como Hipervisor.

   - Vagrant
   - Docker
   - Docker Compose
   - Shell script
   - Mysql

- 01 - Vagrantfile para o provisionamento das 2 VM's;
   - Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.define "db" do |db|	
		db.vm.box = "ubuntu/bionic64"
		db.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
		db.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
		db.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
		db.vm.network "public_network", ip:"192.168.1.111", bridge:	"wlp2s0"	  
		db.vm.provision "file", source: "~/lab/lab-02/docker-compose-db.yml", destination: "~/docker-compose.yml" 
		db.vm.provision "shell", path: "db.sh"
	end
	config.vm.define "ubuntu" do |ubuntu|	
		ubuntu.vm.box = "ubuntu/bionic64"
		ubuntu.ssh.insert_key = false
		ubuntu.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
		ubuntu.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
		ubuntu.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
		ubuntu.vm.network "public_network", ip:"192.168.1.110", bridge:	"wlp2s0"  
		ubuntu.vm.provision "file", source: "~/lab/lab-02/docker-compose-wp.yml", destination: "~/docker-compose.yml" 
		ubuntu.vm.provision "shell", path: "wordpress.sh"
	end

end

```

- config.vm.box = "ubuntu/bionic64"
    - define a boxe que utilizei.

`
No arquivo estou provisionando as duas VM's de uma vez então os comando são bem semelhantes. Vou citar a VM do servidor de containers e o por comparação, pode ser entendido o codigo referente a VM do servidor de proxy.
`

- config.vm.define "db" do |db|
    - docker.vm.hostname = "db"

`
Cria a VM docker e da o nome para o host.
`

- db.ssh.insert_key = false
- db.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
- db.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
`
Envia minha chave ssh publica para a Vm para que possa ser acessado via terminal posteriormente.
Para que este comando funcione, deve ser criado um par de chaves ssh na home de seu Ubuntu, com o comando "ssh-keygen"
`

- db.vm.network "public_network", ip:"192.168.1.111", bridge: "wlp2s0"
`
Cria uma rede publica em modo bridge com minha interface de rede "wlp2s0" e força o ip fixo 192.168.1.110 para a maquina.
`

- db.vm.provision "file", source: "~/lab/lab-02/docker-compose-db.yml", destination: "~/docker-compose.yml" 
`
Envia o arquivo docker compose para dentro da VM. Lembrando que o sorce tem que conter o caminho do arquivo em sua maquina fisica.
`

- docker.vm.provision "shell", path: "db.sh"

`
Executa o script shell db.sh
`

- 02 - SHELL SCRIPT: docker.sh:

```
#!/bin/bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
docker-compose up -d
sudo docker ps
```

`
O script realiza a atualização do apt-get, instala o docker e docker compose, consecutivamente inicia o docker e o deixa ativo.  
Após isto provê os serviços descritos no arquivo docker compose.
Ao final mostra os containers rodando.
`

- 02.1 - docker-compose-db.yml
```
version: '3'
services:
  db:
    image: 'mysql:latest'
    container_name: db
    ports:
      - '3306:3306'
    restart: always  
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppass
    volumes:
      - mysql:/var/lib/mysql
volumes:
  mysql:   

```

`
Neste arquivo é feita a configuração do container mysql, configuração do redirecionamento de portas, volumes e as variaveis de ambiente.
`

- 03 - SHELL SCRIPT: wordpress.sh:

```
#!/bin/bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker docker.socket containerd
sudo systemctl enable docker
sudo systemctl start docker
docker-compose up -d
sudo docker ps
```

`
Executa os mesmo comandos do db.sh, porém o docker-compose é diferente.
`

- 03.1 - docker-compose-wp.yml

```
version: '3'
services:  
  wp:
    image: 'wordpress:latest'
    container_name: wp
    ports:
      - '8080:80'
      - '443:433'
    restart: always
    environment:
      WORDPRESS_DB_HOST: 192.168.1.111:3306
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
    volumes:
        - wp_data:/var/www/html    

volumes:
  wp_data:


```

`
Neste arquivo é feita a configuração do container wordpress, configuração do redirecionamento de portas, volumes e as variaveis de ambiente.
`

