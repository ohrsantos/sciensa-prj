#!/bin/bash

VERSION="latest"
SCIENSA_JENKINS_HOME=/var/lib/docker/volumes/jenkins_docker_home/_data
WORK_DIR=$(pwd)

cd $SCIENSA_JENKINS_HOME

sudo rm -rf jobs/Node-App-DEV/nextBuildNumber jobs/Node-App-DEV/builds/*
sudo rm -rf jobs/Node-App-PROD/nextBuildNumber jobs/Node-App-PROD/builds/*

tar zcvf sciensa-jenkins.tar.gz *

#This version is for the case with need hidden files
#tar zcvf sciensa-jenkins.tar.gz * .??*

mv sciensa-jenkins.tar.gz $WORK_DIR

cd -

docker build -f Dockerfile.sciensa-jenkins-docker  -t ohrsan/sciensa-jenkins-docker:$VERSION .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/sciensa-jenkins-docker:$VERSION
