#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done


#### This script is copied to the newly minted EC2 instance and used to install everything else
#### Ideally, this would be Puppet or Chef instead for anything even mildly more complicated.

echo "bootstrap.sh"
sudo add-apt-repository universe -y
sudo apt-get update -y -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install ffmpeg supervisor python3.7 python3-pip -y -qq
#sudo apt-get install supervisor -y
#sudo apt-get install python3.7 -y
#sudo apt-get install python3-pip  -y
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2
echo "2" | sudo update-alternatives --config python3
sudo apt-get update -y -qq

echo "::PYTHON VERSION:: $(python3 --version)"


python3 -m pip install pipenv

PROCESSOR_DIR=$HOME/processor 
rm -rf $PROCESSOR_DIR

# git clone https://github.com/joshlong/podcast-production-pipeline-ffmpeg.git $PROCESSOR_DIR
GIT_REPO=https://github.com/bootiful-podcast/processor.git
git clone $GIT_REPO $PROCESSOR_DIR
cd $PROCESSOR_DIR 
source $HOME/env.sh
python3 -m pipenv install
python3 -m pipenv run python ${PROCESSOR_DIR}/config_aws.py $HOME/.aws/

SVC_DIR=${PROCESSOR_DIR}/service
SVC_ENV=${SVC_DIR}/processor-environment.sh
SVC_INIT=${SVC_DIR}/processor-service.sh

cat $HOME/env.sh >> ${SVC_ENV}



${SVC_DIR}/install.sh

### DANGER
### this will remove ALL firewall rules:
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
###