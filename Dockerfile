FROM centos:6
MAINTAINER itspoma <itspoma@gmail.com>

RUN yum clean all \
 && yum install -y which wget curl gcc-c++ tar git \
 && yum install -y mc

WORKDIR /shared

CMD ["/bin/bash"]
