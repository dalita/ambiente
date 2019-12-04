FROM centos:7
MAINTAINER Dalita <dalitagh@gmailcom>

# Need root to build image
USER root
# install dev tools

RUN yum install -y \
      unzip \
      tar \
      gzip \
      wget
RUN yum -y update 

# install docker

# install dockr-compose
RUN mkdir -p docker-compose && \ 
    cd docker-compose && \
    curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl 
RUN chmod +x ./kubectl 
RUN mv ./kubectl /usr/local/bin/kubectl

# install Virtualbox (Example version: 5.0.14_105127_el7-1)
RUN export VIRTUALBOX_VERSION=latest && \
    mkdir -p /opt/virtualbox && \
    cd /etc/yum.repos.d/ && \
    wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo && \
    yum install -y \
      dkms \
      kernel-devel && \
    yum -y groupinstall "Development Tools" && \
    if  [ "${VIRTUALBOX_VERSION}" = "latest" ]; \
      then yum install -y VirtualBox-5.0 ; \
      else yum install -y VirtualBox-5.0-${VIRTUALBOX_VERSION} ; \
    fi && \
    yum clean all && rm -rf /var/cache/yum/* && rm -rf /tmp/*

# install minikube
RUN curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
RUN cp minikube /usr/local/bin && \
    rm minikube
