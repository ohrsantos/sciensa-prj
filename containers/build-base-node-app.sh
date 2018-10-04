#!/bin/bash

password=${1}

docker build -f Dockerfile.base-node-app -t ohrsan/base-node-app .

docker login -u=ohrsan -p=$password

docker push ohrsan/base-node-app
