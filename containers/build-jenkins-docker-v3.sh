#!/bin/bash
docker build -f Dockerfile.jenkins-docker-v3  -t ohrsan/jenkins-docker:v3 .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/jenkins-docker:v3
