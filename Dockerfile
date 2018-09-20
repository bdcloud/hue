#FROM openjdk:8-jdk
FROM bdcloud/python2-base

ENV HUE_VERSION 3.12.0


RUN apt-get update 
RUN apt-get install -y wget 
RUN apt-get install --no-install-recommends -y \
    build-essential python2.7-dev libsasl2-dev \
    libsqlite3-dev libkrb5-dev libffi-dev libxml2-dev \
    libxslt1-dev libgmp-dev libssl-dev libldap2-dev \
    libmysqld-dev rsync 

ADD ./apache-maven-3.5.4-bin.tar /
RUN mv apache-maven-3.5.4 /opt/maven
RUN export PATH=/opt/maven/bin:$PATH

RUN useradd hue 

ADD ./hue-${HUE_VERSION}.tgz / 
RUN  cd /hue-${HUE_VERSION} \
  && make install \
  && chown -R hue /usr/local/hue \
  && cd / \
  && rm -rf /hue-${HUE_VERSION} 
RUN apt-get autoremove -y build-essential
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./hue.ini /usr/local/hue/desktop/conf/hue.ini

EXPOSE 8888
ENTRYPOINT ["/usr/local/hue/build/env/bin/hue"]
CMD ["runcpserver"]

