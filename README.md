```bash
# install system dependencies
$ sudo apt-get update
$ sudo apt-get install -y apt-transport-https ca-certificates
$ sudo apt-get install -y curl mc

# install docker
$ curl -fsSL https://get.docker.com/ | sh
$ sudo usermod -aG docker $(whoami)
$ docker --version
$ docker version
$ sudo service docker restart

# install docker-compose
$ sudo apt-get -y install python-pip
$ sudo pip install docker-compose
$ docker-compose --version

# install docker's fig
$ sudo pip install -U fig
$ fig --version

# configure docker to use another storage driver
$ sudo echo 'DOCKER_OPTS="--storage-driver=devicemapper"' >> /etc/default/docker
$ sudo service docker restart

# get bugzilla source code
$ git clone https://github.com/dklawren/docker-bugzilla.git ~/bugzilla
$ cd ~/bugzilla

# setup bugzilla config
$ export BUGZILLA_HOST='52.39.46.90'
$ export BUGZILLA_VERSION='5.0'
$ export BUGZILLA_ADMIN_EMAIL='admin@bugzilla.app'
$ export BUGZILLA_ADMIN_PASSWORD='Xrtwg7q5bXv'

$ sed "s/^ENV GITHUB_BASE_BRANCH.*/ENV GITHUB_BASE_BRANCH ${BUGZILLA_VERSION}/" -i Dockerfile
$ sed "s/.*urlbase.*/ \$answer\{'urlbase'} = 'http:\/\/${BUGZILLA_HOST}:8080\/bugzilla';/" -i checksetup_answers.txt
$ sed "s/.*ADMIN_EMAIL.*/ \$answer\{'ADMIN_EMAIL'} = '${BUGZILLA_ADMIN_EMAIL}';/" -i checksetup_answers.txt
$ sed "s/.*ADMIN_PASSWORD.*/ \$answer\{'ADMIN_PASSWORD'} = '${BUGZILLA_ADMIN_PASSWORD}';/" -i checksetup_answers.txt

# build container
$ docker build --rm -t itspoma/docker-bugzilla .

# run container
$ docker run -d -t \
    --name bugzilla --hostname bugzilla \
    --publish 80:80 --publish 2222:22 \
    itspoma/docker-bugzilla

# to access via ssh into container
$ docker exec -ti bugzilla bash

# to cleanup container
$ docker stop bugzilla
$ docker rm bugzilla

# to cleanup docker images & containers
$ docker ps -a
$ docker rm -f $(docker ps -aq)

$ docker images -a
$ docker rmi -f $(docker images -qa)
```
