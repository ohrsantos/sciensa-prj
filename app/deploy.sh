#!/bin/bash
#cd app

action=$(echo ${1} | tr '[:lower:]' '[:upper:]')

export APP_ENV=$(echo ${2} | tr '[:lower:]' '[:upper:]')
export PUBLIC_DNS=${3}
APP_PORT=${4}

echo ">>>> deploy-${APP_ENV} v:0.34a"

function stop {
    echo ">>>> Parando container sciensa-app-${APP_ENV} ..."
    if docker stop -t3 sciensa-app-${APP_ENV}; then
        echo ">>>> Container parado com sucesso!"
    fi
    echo ">>>> Removendo imagem ..."
    docker rmi -f ohrsan/node-sciensa-prj:${APP_ENV} || exit 1
    echo ">>>> Imagem removida com sucesso ..."
}

function start {
    if git pull https://github.com/ohrsantos/sciensa-prj.git; then
        echo ">>>> Codigos da aplicacao atualizados com sucesso!"
    else
        echo "git pull, falhou!!!"
        exit 2
    fi
    echo ">>>> Construindo a imagem com o codigo atualizado..."
    cd containers
    if docker  build -f Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:${APP_ENV} .; then
        echo ">>>> Imagem construida com sucesso!"
        echo ">>>> Inicializando container sciensa-app-${APP_ENV} $HOST:$APP_PORT"
        docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p $APP_PORT:3000 -p 3001:3001 -v /var/www  --name sciensa-app-${APP_ENV} ohrsan/node-sciensa-prj:${APP_ENV} || exit 3
    else
        exit 4
    fi
}

case $action in
    "STOP" )
        echo "----------------------------------"
        echo "      ENCERRANDO $APP_ENV "
        echo "----------------------------------"
        stop
        ;;
    "START" )
        echo "----------------------------------"
        echo "      INICIALIZANDO $APP_ENV "
        echo "----------------------------------"
        start
        ;;
    "UPDATE" )
        echo "----------------------------------"
        echo "      DEPLOYING $APP_ENV "
        echo "----------------------------------"
        stop
        start
        ;;
    *)
         echo "Opcao \"$action\"... invalida!"
        ;;
esac
exit 0
