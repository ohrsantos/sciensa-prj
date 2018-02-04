#!/bin/ksh
#        1         2         3         4         5         6         7         8         9
#234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################
SCRIPT_NAME="dev.sciensa-prj.run-aws-instance"
#This script is a template to be modified and "save as" for the specific
#instance launch. Note that it contains variables and container run command
#if container will not be used, dissmis those parametrization accordantly
################################################################################
VERSION="0.10a"
AUTHOR="Orlando Hehl Rebelo dos Santos"
DATE_INI="14-01-2018"
DATE_END="04-02-2018"
################################################################################
#Changes:
#
################################################################################


################################################################################
#Configuration section:
#
PROFILE_USR="a1"
REGION="us-east-1"

if [[ $1 != "CREATE" ]]; then INSTANCE_DRY_RUN="--dry-run"; fi
INSTANCE_KEY_PAIR="ohrs-aws-key-file"
INSTANCE_SECURITY_GRP="ohrs-default"
INSTANCE_NAME="sciensa-prj-DEV2"
INSTANCE_USR="ec2-user"
INSTANCE_AMI_ID="ami-428aa838"
INSTANCE_TYPE="t2.micro"
INSTANCE_COUNT="1"
INSTANCE_DATA_FILE="user-data.txt"

JENKINS_CONTAINER="docker run -d --rm -u root\
                   -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_docker_home:/var/jenkins_home\
                   -p 8080:8080 -p 50000:50000\
                   --name dev-sciensa-jenkins-docker\
                   ohrsan/sciensa-jenkins-docker:v2"

APP_CONTAINER="PUBLIC_DNS=NA APP_ENV=DEV docker run -d --rm -e APP_ENV -e PUBLIC_DNS\
              -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-DEV ohrsan/node-sciensa-prj:DEV"

################################################################################
# Macros:
AWS="aws --profile $PROFILE_USR --region $REGION"

INSTANCES_TMP_FILE=".aws-shell.tmp"

################################################################################
# Insert/Delete or change the lines as desired of the 'user_data" array bellow:

user_data=(

"#!/bin/bash"

#Update the installed packages and package cache on your instance.
"yum update -y"

#set locale
"localectl set-locale LANG=en_US.utf8"

#Ksh93 for professional shell scripts... Yeah, ksh rocks!!!
"yum install -y ksh"

#Install the most recent Docker Community Edition package.
"yum install -y docker"

#Add the ec2-user to the docker group so you can execute Docker commands without using sudo.
"usermod -a -G docker ec2-user"

#Start the Docker service.
"service docker start"

#Automatic docker service startup
"chkconfig docker on"

"chmod +x /etc/rc.d/rc.local"


#Java installation
#"yum install -y git java-1.8.0-openjdk-devel"
#"alternatives --config java"

"echo ${INSTANCE_NAME} > /home/ec2-user/.instance-name.ohrs"

"sleep 30"

"docker login -u=ohrsan -p=bomdia01 >> /home/ec2-user/rc.local.log 2>&1"
"docker pull node:latest >> /home/ec2-user/rc.local.log 2>&1"
"${APP_CONTAINER} >> /home/ec2-user/rc.local.log 2>&1"
"${JENKINS_CONTAINER} >> /home/ec2-user/rc.local.log 2>&1"


#Creating  /etc/rc.d/rc.local:
#"echo sleep 5 >> /etc/rc.d/rc.local"
#"echo \"for (( i = 0 ; i < 10; i++ )); do\" >> /etc/rc.d/rc.local"
#"echo \"    pgrep dockerd && /usr/bin/docker start ${CONTAINER_APP_NAME}-app-${CONTAINER_TAG} > /home/$INSTANCE_USR/${CONTAINER_APP_NAME}-app-${CONTAINER_TAG}.docker.log 2>&1; chmod 777 /home/$INSTANCE_USR/${CONTAINER_APP_NAME}-app-${CONTAINER_TAG}.docker.log; exit 0\" >> /etc/rc.d/rc.local"
#"echo \"    echo sleeping 3 seconds...\" >> /etc/rc.d/rc.local"
#"echo \"    sleep 3\" >> /etc/rc.d/rc.local"
#"echo \"done\" >> /etc/rc.d/rc.local"

#Creating  /etc/rc.d/rc.local:
"echo sleep 20 >> /etc/rc.d/rc.local"

"echo 'docker login -u=ohrsan -p=bomdia01 >> /home/ec2-user/rc.local.log 2>&1' >> /etc/rc.d/rc.local"

"echo 'docker pull node:latest >> /home/ec2-user/rc.local.log 2>&1' >> /etc/rc.d/rc.local"
"echo \"${APP_CONTAINER} >> /home/ec2-user/rc.local.log 2>&1\" >> /etc/rc.d/rc.local"
"echo \"${JENKINS_CONTAINER} >> /home/ec2-user/rc.local.log 2>&1\" >> /etc/rc.d/rc.local"

#"echo 'PUBLIC_DNS=NA APP_ENV=DEV docker run -d --rm -e APP_ENV -e PUBLIC_DNS -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-DEV ohrsan/node-sciensa-prj:DEV >> /home/ec2-user/rc.local.log 2>&1' >> /etc/rc.d/rc.local"
# Docker run command ..."
#"su $INSTANCE_USR -c \"${JENKINS_CONTAINER}\""
#"su $INSTANCE_USR -c \"${JENKINS_CONTAINER}\""

)


################################################################################
# user-data file section:

> $INSTANCE_DATA_FILE
for index in "${!user_data[@]}"; do 
    echo "${user_data[$index]}" >> $INSTANCE_DATA_FILE
    echo "${user_data[$index]}" 
done
    echo "Initializing instance..."
    new_image_id=$($AWS --output json ec2 run-instances $INSTANCE_DRY_RUN --image-id  $INSTANCE_AMI_ID --count $INSTANCE_COUNT --instance-type $INSTANCE_TYPE --key-name $INSTANCE_KEY_PAIR --security-groups $INSTANCE_SECURITY_GRP --user-data file://$(pwd)/$INSTANCE_DATA_FILE --tag-specifications "[ { \"ResourceType\": \"instance\", \"Tags\": [ { \"Key\": \"Name\", \"Value\": \"${INSTANCE_NAME}\" } ] } ] " | grep InstanceId  | tr -d ' ",' | awk -F: '{print $2}')
    
    echo "Instance created, summary:"
    $AWS ec2 describe-instances --filters "Name=instance-id, Values=$new_image_id"

#echo "${INSTANCE_NAME}" > .instance-name.ohrs
#echo "Wait a little bit to strike \"ENTER\" key in order to send the \".instance-name\" file..."
#aws-sh-tk -u a1 -r us-east-1  -l -a scp -K ohrs-aws-key-file $(pwd)/.instance-name.ohrs  \~
