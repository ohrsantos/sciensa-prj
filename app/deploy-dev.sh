#!/bin/bash

cd app

action=${1}

HOST=ec2-34-239-132-79.compute-1.amazonaws.com

function stop {
    echo "Parando container sciensa-app-dev ..."
    if docker stop -t3 sciensa-app-dev; then
    echo "Container parado com sucesso!"
    echo "Removendo imagem ..."
        docker rmi -f ohrsan/node-sciensa-prj:dev || exit 2
    else
        exit 1
    fi
}

function start {
    echo "Construindo a imagem com o codigo atualizado..."
    if docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:dev .; then
        echo "Imagem contruida com sucesso!"
        echo "Inicializando container sciensa-app-dev na porta $PORTA..."
        APP_ENV=DEV PUBLIC_DNS=$HOST docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-dev ohrsan/node-sciensa-prj:dev || exit 4
    else
        exit 3
    fi
}

case $action in
    stop )
        echo "/*------------------------------*/"
        echo "   ***   ENCERRANDO ***"
        echo "/*------------------------------*/"
        stop
        ;;
    start )
        echo "/*------------------------------*/"
        echo "   ***   INICIALIZANDO ***"
        echo "/*------------------------------*/"
        start
        ;;
    restart )
        echo "/*------------------------------*/"
        echo "   ***   REINICIANDO ***"
        echo "/*------------------------------*/"
        stop
        start
        ;;
    *)
         echo "Opcao invalida!"
        ;;
esac
exit 0
