docker run -d -u root -v /var/run/docker.sock:/var/run/docker.sock  -v jenkins_docker_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 --name dev-sciensa-jenkins-docker ohrsan/jenkins-docker:v2
