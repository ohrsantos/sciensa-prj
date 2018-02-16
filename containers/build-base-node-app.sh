#!/bin/bash
docker build -f Dockerfile.base-node-app -t ohrsan/base-node-app .

docker login -u=ohrsan -p=bomdia01

docker push ohrsan/base-node-app
