#!/bin/bash
echo "######################################################################"
echo "                      *** DESCONTINUADO ***
echo "                      ***   DEPRICATED  ***
echo "######################################################################"

exit 255

echo ">>> deploy-prod v:0.32a"

cd app

action=${1}

export APP_ENV="PROD"
HOST=ec2-54-91-147-118.compute-1.amazonaws.com
export PUBLIC_DNS=$HOST
APP_PORT=3000

function stop {
    echo ">>> Parando container sciensa-app-prod ..."
    if docker stop -t3 sciensa-app-prod; then
       echo ">>> Container parado com sucesso!"
       echo ">>> Removendo imagem ..."
        docker rmi -f ohrsan/node-sciensa-prj:prod || exit 2
    else
        exit 1
    fi
}

function start {
    echo ">>> Construindo a imagem com o codigo atualizado..."
    if docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:prod .; then
        echo ">>> Imagem construida com sucesso!"
        echo ">>> Inicializando container sciensa-app-prod $HOST:$APP_PORT"
        docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p $APP_PORT:3000 -p 3001:3001 -v /var/www  --name sciensa-app-prod ohrsan/node-sciensa-prj:prod || exit 4
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
