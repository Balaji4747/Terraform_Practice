#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enablenginx
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html

