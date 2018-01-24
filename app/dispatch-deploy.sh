#!/bin/bash

ssh -i ohrs-aws-key-file.pem ec2-user@ec2-54-89-229-198.compute-1.amazonaws.com <<< "cd /home/ec2-user/deploy/sciensa-prj/; app/deploy-prod.sh restart"
