#!/bin/bash
sudo rpm --import https://repo.saltproject.io/salt/py3/amazon/2/x86_64/latest/SALTSTACK-GPG-KEY.pub
curl -fsSL https://repo.saltproject.io/salt/py3/amazon/2/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt-amzn.repo
sudo yum clean expire-cache
sudo yum install salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api -y
sudo systemctl enable salt-master && sudo systemctl start salt-master
sudo systemctl enable salt-minion && sudo systemctl start salt-minion
sudo systemctl enable salt-syndic && sudo systemctl start salt-syndic
sudo systemctl enable salt-api && sudo systemctl start salt-api
sudo hostnamectl set-hostname aws-saltmaster
sudo touch /etc/salt/minion.d/minion.conf && sudo echo "master: localhost" > /etc/salt/minion.d/minion.conf
sudo touch /etc/salt/master.d/master.conf && sudo echo "auto_accept: True" > /etc/salt/master.d/master.conf
sudo systemctl restart salt-master && sudo systemctl restart salt-minion