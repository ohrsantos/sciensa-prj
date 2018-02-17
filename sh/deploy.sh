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
        docker rm -f sciensa-app-${APP_ENV}
    fi
    echo ">>>> Removendo imagem ..."
    if docker rmi -f ohrsan/node-sciensa-prj:${APP_ENV}; then
        echo ">>>> Imagem removida com sucesso ..."
    else
        echo ">>>> ATENCAO: A imagem nao foi removida com sucesso ..."
    fi

}

#rancher --url http://10.211.55.38:8080/v2-beta/projects/1a5 --access-key D9C4A756AC8A5BD492AF --secret-key HcnLaZzJskb2udNNeWdrYt7ZJ8HRFCH2fMuJuYYy  --env Default up -d --pull  --stack node-app-stack --force-upgrade
#rancher --url http://10.211.55.38:8080/v2-beta/projects/1a5 --access-key D9C4A756AC8A5BD492AF --secret-key HcnLaZzJskb2udNNeWdrYt7ZJ8HRFCH2fMuJuYYy  --env Default up -d --pull --stack node-app-stack --confirm-upgrade
#rancher --url http://10.211.55.38:8080/v2-beta/projects/1a5 --access-key D9C4A756AC8A5BD492AF --secret-key HcnLaZzJskb2udNNeWdrYt7ZJ8HRFCH2fMuJuYYy  --env Default scale node-app=4

function start {
    if git pull https://github.com/ohrsantos/sciensa-prj.git; then
        echo ">>>> Codigos da aplicacao atualizados com sucesso!"
    else
        echo "git pull, falhou!!!"
        exit 2
    fi
    echo ">>>> Construindo a imagem com o codigo atualizado..."
    if docker  build -f containers/Dockerfile.sciensa-app -t ohrsan/node-sciensa-prj:${APP_ENV} .; then
        echo ">>>> Imagem construida com sucesso!"
        echo ">>>> Inicializando container sciensa-app-${APP_ENV} $HOST:$APP_PORT"
        docker run -d  --rm -e APP_ENV -e PUBLIC_DNS -p $APP_PORT:3000 -p 3001:3001 -v /var/www  --name sciensa-app-${APP_ENV} ohrsan/node-sciensa-prj:${APP_ENV} || exit 3
    else
        exit 4
    fi
}

function run_tests {
    sleep 5
    echo ">>>> Testando a aplicacao..."
    if ! ./sh/is-server-up.sh -D  && ./sh/has-error-string.sh -D && ./sh/is-rds-select-working.sh -D; then
        TESTS=FAILED
        echo ">>>> Testes falharam!"
    fi

    stop

    if [[ $TESTS == FAILED ]]; then exit 50; fi
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
        run_tests
        ;;
    *)
         echo "Opcao \"$action\"... invalida!"
        ;;
esac
exit 0
