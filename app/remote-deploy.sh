#!/bin/bash

if [[ REMOTE_DEPLOY == "FALSE" ]]; then exit 0;fi
echo $REMOTE_DEPLOY
exit 0

action=${1}
APP_ENV=${2}
PROD_HOST=${3}
PORT=${4}

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/node-sciensa-prj:DEV

ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< \
        "docker stop -t3 sciensa-app-PROD; \
         docker rmi ohrsan/node-sciensa-prj:DEV; \
         PUBLIC_DNS=$PROD_HOST APP_ENV=PROD \
         docker run -d --rm \
             -e APP_ENV -e PUBLIC_DNS \
             -p $PORT:3000 -p 3001:3001 \
             -v /var/www  \
             --name sciensa-app-PROD \
             ohrsan/node-sciensa-prj:DEV"
