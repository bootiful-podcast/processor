#!/usr/bin/env bash

## taking the encrypted value in the Travis environment and turning it into the file called `$HOME/podcast.pem`.
##
echo "travis_install.sh"

PEM=$HOME/podcast.pem

## If you want to 
# openssl aes-256-cbc -K $encrypted_58bca13bc34f_key -iv $encrypted_58bca13bc34f_iv -in podcast-processor-kp.pem.enc -out $PEM -d
openssl aes-256-cbc -K $encrypted_36e695aa466a_key -iv $encrypted_36e695aa466a_iv -in podcast-processor-kp.pem.enc -out $PEM -d


## turning the Travis environment variables and turning them into the AWS `$HOME/.aws/{credentials,config}` files
python ./config_aws.py $HOME/.aws/

