#!/bin/bash
PROD_HOST=${1}

ssh -i ohrs-aws-key-file.pem ec2-user@$PROD_HOST <<< "cd /home/ec2-user/deploy/sciensa-prj/; app/deploy-prod.sh restart"
