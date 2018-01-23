#!/bin/bash

action=${1}

case $action in
    stop )
        docker stop -t5 sciensa-app-prod
        docker rmi -f ohrsan/node-sciensa-prj:prod
        ;;
    start )
        docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:prod .
        APP_ENV=PROD PUBLIC_DNS=ec2-54-89-229-198.compute-1.amazonaws.com docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-prod ohrsan/node-sciensa-prj:prod
        ;;
    restart )
        docker stop -t5 sciensa-app-prod
        docker rmi -f ohrsan/node-sciensa-prj:prod
        docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:prod .
        APP_ENV=PROD PUBLIC_DNS=ec2-54-89-229-198.compute-1.amazonaws.com docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  ohrsan/node-sciensa-prj:prod  --name sciensa-app-prod
        ;;
    *)
         echo "Opcao invalida!"
        ;;
esac
