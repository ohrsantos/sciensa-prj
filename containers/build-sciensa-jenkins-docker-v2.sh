#!/bin/bash
docker build -f Dockerfile.sciensa-jenkins-docker-v3  -t ohrsan/sciensa-jenkins-docker:v3 .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/sciensa-jenkins-docker:v3
