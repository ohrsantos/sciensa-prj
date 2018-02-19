#!/bin/bash

VERSION="latest"
JENKINS_HOME=/var/lib/docker/volumes/jenkins_docker_home/_data
WORK_DIR=$(pwd)

cd $JENKINS_HOME

sudo rm -rf jobs/Node-App-DEV/nextBuildNumber jobs/Node-App-DEV/builds/*
sudo rm -rf jobs/Node-App-PROD/nextBuildNumber jobs/Node-App-PROD/builds/*

tar zcvf jenkins_home.tar.gz *

#This version is for the case with need hidden files
#tar zcvf jenkins_home.tar.gz * .??*

mv jenkins_home.tar.gz $WORK_DIR

cd -

docker build -f containers/Dockerfile.ohrs-jenkins  -t ohrsan/ohrs-jenkins:$VERSION .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/ohrs-jenkins:$VERSION
