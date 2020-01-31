#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
echo "install.sh"


ROOT_FS=/home/ubuntu/processor/service
SVC_NAME=processor
THIS_DIR=$(cd `dirname $0 ` && pwd )


### nginx
sudo apt install nginx -y -qq
sudo service nginx start
sudo rm -rf /etc/nginx/sites-enabled/*
sudo rm -rf /etc/nginx/sites-available/*
sudo cp ${ROOT_FS}/processor-nginx.conf /etc/nginx/conf.d/processor-nginx.conf
sudo service nginx restart  -y || echo "couldn't restart with -y..."

### supervisord
echo "starting supervisor -y -qq..."
sudo service start supervisor -y -qq
CONF_FN=/etc/supervisor/conf.d/${SVC_NAME}.conf
mkdir -p `dirname ${CONF_FN}`
sudo cp ${ROOT_FS}/supervisor.conf ${CONF_FN}
sudo supervisorctl update
sudo supervisorctl reread
#sudo supervisorctl start ${SVC_NAME} || echo "couldn't start supervisor"
