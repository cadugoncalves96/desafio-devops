#!/bin/bash
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker login -u ${registry_user} -p ${registry_pwd} ${registry_url} 
sudo docker run -it --log-opt max-size=10m --log-opt max-file=3 \
                    -p 8080:8080 \
                    -d --name ${app} ${registry_url}/${app}:${app_tag}
sudo touch /var/log/${app}-${env}.log
sudo docker logs -f ${app} &> /var/log/${app}-${env}.log &