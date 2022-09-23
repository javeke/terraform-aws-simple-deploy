#! /bin/bash

echo "Installing Nginx Web server"

sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx


echo "Installing Docker Engine"

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


echo "Starting Docker Engine"

sudo service docker start


echo "Pulling Docker compose from repo"

sudo curl -o .env https://raw.githubusercontent.com/javeke/learning-track-1/challenge-3-new/.env
sudo curl -o docker-compose.yml https://raw.githubusercontent.com/javeke/learning-track-1/challenge-3-new/docker-compose.yml
sudo docker compose -f docker-compose.yml up -d



echo "Pulling Nginx configuration from repo"


sudo curl -o default https://raw.githubusercontent.com/javeke/learning-track-1/challenge-3-new/reverse_proxy.conf
sudo mv default /etc/nginx/sites-available/default


sudo service nginx restart