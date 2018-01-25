#!/bin/bash

echo ">>>> remote-deploy v:0.3.0a"

action=$(echo ${1} | tr '[:lower:]' '[:upper:]')
APP_ENV=${2}
PROD_HOST=${3}
PORT=${4}


docker login -u=ohrsan -p=bomdia01

docker push ohrsan/node-sciensa-prj:DEV

case $action in
    "INITIALIZE" )
        echo "----------------------------------"
        echo "      INICIALIZANDO $APP_ENV "
        echo "----------------------------------"
        ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< \
                "docker pull node:latest; \
                 PUBLIC_DNS=$PROD_HOST APP_ENV=PROD \
                 docker run -d --rm \
                     -e APP_ENV -e PUBLIC_DNS \
                     -p $PORT:3000 -p 3001:3001 \
                     -v /var/www  \
                     --name sciensa-app-PROD \
                     ohrsan/node-sciensa-prj:DEV"
        ;;
    "STOP" )
        echo "----------------------------------"
        echo "      ENCERRANDO $APP_ENV "
        echo "----------------------------------"
        ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< \
                "docker stop -t3 sciensa-app-PROD; \
                 docker rmi ohrsan/node-sciensa-prj:DEV"
        ;;
    "START" )
        echo "----------------------------------"
        echo "      INICIANDO $APP_ENV "
        echo "----------------------------------"
        ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< \
                "PUBLIC_DNS=$PROD_HOST APP_ENV=PROD \
                 docker run -d --rm \
                     -e APP_ENV -e PUBLIC_DNS \
                     -p $PORT:3000 -p 3001:3001 \
                     -v /var/www  \
                     --name sciensa-app-PROD \
                     ohrsan/node-sciensa-prj:DEV"
        ;;
    "UPDATE" )
        echo "----------------------------------"
        echo "      DEPLOYING $APP_ENV "
        echo "----------------------------------"
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
        ;;
    *)
        echo "Action: $action"
        exit 0
        ;;
esac
