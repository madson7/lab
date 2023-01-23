Vagrant.configure("2") do |config|
    (1..2).each do |i|
        config.vm.define "web_#{i}" do |web|
            web.vm.box = "ubuntu/bionic64"
            web.vm.network "public_network", bridge: "enp3s0", ip: "192.168.128.7#{i}"
            web.vm.provision "shell", path: "httpd_#{i}.sh"
        end
    end
end





  