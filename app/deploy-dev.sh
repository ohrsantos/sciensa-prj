#!/bin/bash
echo ">>> deploy-dev v:0.32a"
cd app

action=${1}

export APP_ENV="DEV"
HOST="ec2-34-239-132-79.compute-1.amazonaws.com"
export PUBLIC_DNS=$HOST
APP_PORT=3000

function stop {
    echo ">>> Parando container sciensa-app-dev ..."
    if docker stop -t3 sciensa-app-dev; then
        echo ">>> Container parado com sucesso!"
        echo ">>> Removendo imagem ..."
        docker rmi -f ohrsan/node-sciensa-prj:dev || exit 2
    else
        exit 1
    fi
}

function start {
    echo ">>> Construindo a imagem com o codigo atualizado..."
    if docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:dev .; then
        echo ">>> Imagem construida com sucesso!"
        echo ">>> Inicializando container sciensa-app-dev $HOST:$APP_PORT"
        docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p $APP_PORT:3000 -p 3001:3001 -v /var/www  --name sciensa-app-dev ohrsan/node-sciensa-prj:dev || exit 4
    else
        exit 3
    fi
}

case $action in
    stop )
        echo "/*------------------------------*/"
        echo "   ***   ENCERRANDO $APP_ENV ***"
        echo "/*------------------------------*/"
        stop
        ;;
    start )
        echo "/*------------------------------*/"
        echo "   ***   INICIALIZANDO $APP_ENV ***"
        echo "/*------------------------------*/"
        start
        ;;
    restart )
        echo "/*------------------------------*/"
        echo "   ***   DEPLOYING $APP_ENV ***"
        echo "/*------------------------------*/"
        stop
        start
        ;;
    *)
         echo "Opcao invalida!"
        ;;
esac
exit 0
