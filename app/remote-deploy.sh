#!/bin/bash

action=${1}
APP_ENV=${2}
PROD_HOST=${3}
PORT=${4}

docker login <<< "bomdia01"
docker push ohrsan/node-sciensa-prj:DEV
#ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< "cd /home/ec2-user/deploy/sciensa-prj/; app/deploy.sh $action $APP_ENV $PROD_HOST $PORT"
