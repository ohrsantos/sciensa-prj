#!/bin/ksh
#        1         2         3         4         5         6         7         8         9
#234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
################################################################################
SCRIPT_NAME="rancher-server.run-aws-instance"
VERSION="0.04a"
AUTHOR="Orlando Hehl Rebelo dos Santos"
DATE_INI="13-02-2018"
DATE_END="14-02-2018"
################################################################################
#Changes:
#
################################################################################


################################################################################
#Configuration section:
#
PROFILE_USR="a1"
REGION="us-east-1"

if [[ $1 != "CREATE" ]]; then
    INSTANCE_DRY_RUN="--dry-run"
fi
INSTANCE_KEY_PAIR="ohrs-aws-key-file"
INSTANCE_SECURITY_GRP="ohrs-default"
INSTANCE_NAME="rancher-server"
INSTANCE_USR="ec2-user"
INSTANCE_AMI_ID="ami-428aa838"
INSTANCE_TYPE="t2.micro"
INSTANCE_COUNT="1"
INSTANCE_DATA_FILE="user-data.txt"

RANCHER_SERVER_CONTAINER="docker run -d --restart=unless-stopped -p 8081:8080 --name rancher-server rancher/server:stable"

#JENKINS_CONTAINER="docker run -d --rm -u root\
#                   -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_docker_home:/var/jenkins_home\
#                   -p 8080:8080 -p 50000:50000\
#                   --name dev-sciensa-jenkins-docker\
#                   ohrsan/sciensa-jenkins-docker:04"
#
#SCIENSA_APP_CONTAINER="PUBLIC_DNS=NA APP_ENV=DEV docker run -d --rm -e APP_ENV -e PUBLIC_DNS\
#              -p 3000:3000 -p 3001:3001 -v /var/www  --name sciensa-app-DEV ohrsan/node-sciensa-prj:DEV"
#
#CPPCMS_CONTAINER="docker run -it --rm -u root -v /opt/cppcms  -p 3333:8080  --name dev-cppcms-docker ohrsan/cppcms:v1"
#
#TUTORIAL_APP_METEOR_CONTAINER_NAME=app-test3-meteor
#TUTORIAL_APP_METEOR_CONTAINER="docker run -d --rm  -p 3333:3000 -v ${TUTORIAL_APP_METEOR_CONTAINER_NAME}:/var/meteor --name ${TUTORIAL_APP_METEOR_CONTAINER_NAME} ohrsan/${TUTORIAL_APP_METEOR_CONTAINER_NAME}:1"

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

"yum install ksh git docker tree htop -y"

#Add the ec2-user to the root group 
"usermod -a -G root ec2-user"

#Add the ec2-user to the docker group so you can execute Docker commands without using sudo.
"usermod -a -G docker ec2-user"


#Start the Docker service.
"service docker start"

#Automatic docker service startup
"chkconfig docker on"


"chmod +x /etc/rc.d/rc.local"



"echo ${INSTANCE_NAME} > /home/ec2-user/.instance-name.ohrs"

"curl -o /etc/profile.d/ohrs-profile.sh https://raw.githubusercontent.com/ohrsantos/etc/master/.ohrs.profile"

"sleep 15"

"docker login -u=ohrsan -p=bomdia01 >> /home/ec2-user/instance-creation.log 2>&1"
#"docker pull node:latest >> /home/ec2-user/instance-creation.log 2>&1"
"${RANCHER_SERVER_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1"
#"${SCIENSA_APP_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1"
#"${JENKINS_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1"
#"${CPPCMS_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1"
#"${TUTORIAL_APP_METEOR_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1"

#"chmod  g+rx /var/lib"
#"chmod  g+rx /var/lib/docker"
#"chmod -R g+rx /var/lib/docker/volumes"
#"chown -R ec2-user:ec2-user /var/lib/docker/volumes/${TUTORIAL_APP_METEOR_CONTAINER_NAME}/_data"

#Creating  /etc/rc.d/rc.local:
"echo sleep 15 >> /etc/rc.d/rc.local"

"echo 'docker login -u=ohrsan -p=bomdia01 >> /home/ec2-user/instance-creation.log 2>&1' >> /etc/rc.d/rc.local"

"echo '#docker pull node:latest >> /home/ec2-user/instance-creation.log 2>&1' >> /etc/rc.d/rc.local"
"echo \"${RANCHER_SERVER_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1\" >> /etc/rc.d/rc.local"
#"echo \"${SCIENSA_APP_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1\" >> /etc/rc.d/rc.local"
#"echo \"${JENKINS_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1\" >> /etc/rc.d/rc.local"
#"echo \"${CPPCMS_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1\" >> /etc/rc.d/rc.local"
#"echo \"${TUTORIAL_APP_METEOR_CONTAINER} >> /home/ec2-user/instance-creation.log 2>&1\" >> /etc/rc.d/rc.local"
)


################################################################################
# user-data file section:

> $INSTANCE_DATA_FILE
for index in "${!user_data[@]}"; do 
    echo "${user_data[$index]}" >> $INSTANCE_DATA_FILE
    #echo "${user_data[$index]}" 
done

echo "Initializing instance..."
new_instance_id=$($AWS --output json ec2 run-instances $INSTANCE_DRY_RUN --image-id  $INSTANCE_AMI_ID \
                       --count $INSTANCE_COUNT --instance-type $INSTANCE_TYPE --key-name $INSTANCE_KEY_PAIR \
                       --security-groups $INSTANCE_SECURITY_GRP --user-data file://$(pwd)/$INSTANCE_DATA_FILE \
                       --tag-specifications "[ { \"ResourceType\": \"instance\", \"Tags\": [ { \"Key\": \"Name\", \"Value\": \"${INSTANCE_NAME}\" } ] } ] " \
                                             | grep InstanceId  | tr -d ' ",' | awk -F: '{print $2}')
    
                       #--credit-specification CpuCredits=unlimited \
echo "Instance created, summary:"
$AWS ec2 describe-instances --filters "Name=instance-id, Values=$new_instance_id"

echo "Waiting for the instance reach running state..."
sleep 60

echo "Attaching instances to their respective target groups..."
$AWS  elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:606784160785:targetgroup/rancher-server/4c4da2ec95c5f5d7 --targets Id=$new_instance_id
#$AWS  elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:606784160785:targetgroup/jenkins-dev/49d5199a83cf3941 --targets Id=$new_instance_id
#$AWS  elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:606784160785:targetgroup/sciensa-dev/30895b398b8dd2bb --targets Id=$new_instance_id
#$AWS  elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:606784160785:targetgroup/cppcms-dev/4c9decd880e3678e  --targets Id=$new_instance_id
