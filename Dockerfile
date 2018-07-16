# default build is for CentOS7, change the base image to fit your build.
FROM centos:centos7
MAINTAINER Sebastien Le Digabel "sledigabel@gmail.com"

RUN yum install -y rpmdevtools mock

RUN cd /root && rpmdev-setuptree && rm -rf rpmbuild/SOURCES/* rpmbuild/SPECS/*
WORKDIR /root/rpmbuild

ADD SOURCES /root/rpmbuild/SOURCES
ADD SPECS /root/rpmbuild/SPECS

ARG CONSUL_VERSION
ARG CONSUL_TEMPLATE_VERSION
ARG BUILD_NUMBER
ARG DIST

CMD set -x \
    && spectool -g -R SPECS/consul.spec --define "_version ${CONSUL_VERSION}" && rpmbuild -ba SPECS/consul.spec --define "_version ${CONSUL_VERSION}" --define "_build_number ${BUILD_NUMBER}" --define "dist .${DIST}" \
    && spectool -g -R SPECS/consul-template.spec --define "_version ${CONSUL_TEMPLATE_VERSION}" && rpmbuild -ba SPECS/consul-template.spec --define "_version ${CONSUL_TEMPLATE_VERSION}" --define "_build_number ${BUILD_NUMBER}" --define "dist .${DIST}" \
    && owner_group=$(stat -c %u:%g RPMS/x86_64) && chown $owner_group RPMS/x86_64/*.rpm
