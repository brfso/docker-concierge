# Concierge Dockerfile
#
# https://github.com/brfso/concierge
#
# Pull base image.
FROM debian:jessie

MAINTAINER "Fernando Oliveira"

# setup java ppa repo
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update -y 

# install java 
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y --no-install-recommends oracle-java8-installer
RUN apt-get autoremove 
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# install base
RUN apt-get install -y wget

## install concierge
ENV CONCIERGE_HOME '/opt/concierge'
RUN wget -O /tmp/concierge.tgz http://eclipse.c3sl.ufpr.br/concierge/download/releases/concierge-incubation-5.0.0.tar.gz 
RUN tar -zxvf /tmp/concierge.tgz -C /opt/ 
RUN ln -s ${CONCIERGE_HOME}-incubation-5.0.0/ ${CONCIERGE_HOME}
RUN rm /tmp/concierge.tgz 

RUN echo '#!/bin/bash' > ${CONCIERGE_HOME}/osgi.sh
RUN echo "cd ${CONCIERGE_HOME} && java -jar framework/org.eclipse.concierge*.jar samples/default.xargs" >> ${CONCIERGE_HOME}/osgi.sh
RUN chmod +x ${CONCIERGE_HOME}/osgi.sh

# Start Concierge Shell
ENTRYPOINT ["/opt/concierge/osgi.sh"] 
