Vagrant.configure("2") do |config|
    
        config.vm.define "web_1" do |web|
            web.vm.box = "ubuntu/bionic64"
            web.vm.network "public_network", bridge: "enp3s0", ip: "192.168.128.71"
            web.vm.provision "file", source: "./docker-compose.yml", destination: "$HOME/docker-compose.yml"
            web.vm.provision "shell", path: "1_wordpress.sh"
        end

        config.vm.define "web_2" do |web|
            web.vm.box = "ubuntu/bionic64"
            web.vm.network "public_network", bridge: "enp3s0", ip: "192.168.128.72"
            web.vm.provision "file", source: "./proxy", destination: "$HOME/proxy"
            web.vm.provision "shell", path: "2_nginx.sh"
            
        end
end  
