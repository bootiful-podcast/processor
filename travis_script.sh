#!/bin/bash 


echo "travis_script.sh"

START=$(pwd)
TERRAFORM_BIN=${START}/deploy/terraform-bin/linux
AWS_PEM_FILE=$HOME/podcast.pem

## make sure terraform is on the CLASSPATH
export PATH=${PATH}:${TERRAFORM_BIN}

cd $START/deploy

## This script contains environment variables we'll need in our AWS application.
tmp_env_script=${START}/tmp/env.sh
mkdir -p `dirname $tmp_env_script`
rm -rf ${tmp_env_script}
echo "export PODCAST_RMQ_ADDRESS=${PODCAST_RMQ_ADDRESS}" >>  $tmp_env_script
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >>  $tmp_env_script
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >>  $tmp_env_script
echo "export CONFIG_FILE_NAME=${CONFIG_FILE_NAME}" >>  $tmp_env_script


##
export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_aws_pem=$AWS_PEM_FILE
export TF_VAR_env_sh=$tmp_env_script

##

terraform init
terraform destroy -input=false -auto-approve
terraform apply -input=false -auto-approve 

# don't want this resident or archived by accident
rm -rf $tmp_env_script