#!/bin/bash
docker build -f Dockerfile.sciensa-jenkins-docker-v2  -t sciensa-jenkins-docker:v2 .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/sciensa-jenkins-docker:v2
