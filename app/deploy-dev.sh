#!/bin/bash

action=${1}

case $action in
    stop )
        docker stop -t5 sciensa-app-dev
        docker rmi -f ohrsan/node-sciensa-prj:dev
        ;;
    start )
        docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:dev .
        APP_ENV=DEV PUBLIC_DNS=ec2-54-89-229-198.compute-1.amazonaws.com docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-dev ohrsan/node-sciensa-prj:dev
        ;;
    restart )
        docker stop -t5 sciensa-app-dev
        docker rmi -f ohrsan/node-sciensa-prj:dev
        docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:dev .
        APP_ENV=DEV PUBLIC_DNS=ec2-34-239-104-53.compute-1.amazonaws.com docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  ohrsan/node-sciensa-prj:dev  --name sciensa-app-dev
        ;;
    *)
         echo "Opcao invalida!"
        ;;
esac
