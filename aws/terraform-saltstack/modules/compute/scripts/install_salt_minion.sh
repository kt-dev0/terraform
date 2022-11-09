#!/bin/bash
sudo rpm --import https://repo.saltproject.io/salt/py3/amazon/2/x86_64/latest/SALTSTACK-GPG-KEY.pub
curl -fsSL https://repo.saltproject.io/salt/py3/amazon/2/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt-amzn.repo
sudo yum clean expire-cache
sudo yum install salt-minion -y
sudo systemctl enable salt-minion && sudo systemctl start salt-minion
sudo touch /etc/salt/minion.d/minion.conf && sudo echo "master: 10.10.1.234" > /etc/salt/minion.d/minion.conf
sudo systemctl restart salt-minion