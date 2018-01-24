#!/bin/bash

cd app

action=${1}

HOST=ec2-34-239-132-79.compute-1.amazonaws.com

function stop {
    if docker stop -t3 sciensa-app-dev; then
        docker rmi -f ohrsan/node-sciensa-prj:dev || exit 2
    else
        exit 1
    fi
}

function start {
    if docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:dev .; then
        APP_ENV=DEV PUBLIC_DNS=$HOST docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-dev ohrsan/node-sciensa-prj:dev || exit 4
    else
        exit 3
    fi
}

case $action in
    stop )
        stop
        ;;
    start )
        start
        ;;
    restart )
        stop
        start
        ;;
    *)
         echo "Opcao invalida!"
        ;;
esac
exit 0
