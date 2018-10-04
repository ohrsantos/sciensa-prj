#!/bin/bash

password=${1}

docker build -f Dockerfile.jenkins-docker-v3  -t ohrsan/jenkins-docker:v3 .

docker login -u=ohrsan -p=$password

docker push ohrsan/jenkins-docker:v3
