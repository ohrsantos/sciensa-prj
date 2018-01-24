#!/bin/bash
PROD_HOST=ec2-54-91-147-118.compute-1.amazonaws.com

ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< "cd /home/ec2-user/deploy/sciensa-prj/; app/deploy-prod.sh restart"
