FROM registry.access.redhat.com/rhel7/rhel:latest

MAINTAINER Bouwen de Vries <vries_b@schiphol.nl>

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid 

LABEL io.k8s.description="Squid Proxy" \
      io.k8s.display-name="Squid 3.x" \
      io.openshift.tags="squid" \
      io.openshift.expose-services="3128:tcp"

RUN yum clean all && \
    yum -y update && \
    yum install -y squid && \
    systemctl enable squid && \
    yum clean all

COPY conf/squid.conf /etc/squid/squid.conf

RUN mkdir /etc/squid/conf.d && \
    chown -R 1001:1001   /etc/squid /var/log/squid && \
    chmod -R a+rX  /etc/squid && \
    chmod -R a+rwX /var/log/squid

USER 1001

EXPOSE 3128/tcp

VOLUME ["${SQUID_CACHE_DIR}"]

CMD ["squid","-f","/etc/squid/squid.conf","-N"]
