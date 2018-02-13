#!/bin/bash

SCIENSA_JENKINS_HOME=/var/lib/docker/volumes/jenkins_docker_home/_data
WORK_DIR=$(pwd)

cd $SCIENSA_JENKINS_HOME

tar zcvf sciensa-jenkins.tar.gz *

#This version is for the case with need hidden files
#tar zcvf sciensa-jenkins.tar.gz * .??*

mv sciensa-jenkins.tar.gz $WORK_DIR

cd -

docker build -f Dockerfile.sciensa-jenkins-docker  -t ohrsan/sciensa-jenkins-docker:3 .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/sciensa-jenkins-docker:v3
