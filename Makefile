CONSUL_VERSION ?= 1.2.2
CONSUL_TEMPLATE_VERSION ?= 0.19.5
BUILD_NUMBER ?= 2
RPM = builds/prod/xcalar-1.0.0-100-installer
DOCKER_RUN_ARGS += --rm -it -e CONSUL_VERSION=$(CONSUL_VERSION) -e CONSUL_TEMPLATE_VERSION=$(CONSUL_TEMPLATE_VERSION) -e BUILD_NUMBER=$(BUILD_NUMBER) \
				   -v `pwd`/RPMS:/root/rpmbuild/RPMS \

all: docker-el7 docker-el6

docker-el7:
	docker build \
		--build-arg=CONSUL_VERSION=$(CONSUL_VERSION) \
		--build-arg=CONSUL_TEMPLATE_VERSION=$(CONSUL_TEMPLATE_VERSION) \
		--build-arg=BUILD_NUMBER=$(BUILD_NUMBER) \
		--build-arg=DIST=el7 \
		--build-arg=http_proxy=$(http_proxy) \
		-t consul-el7 .
	docker run $(DOCKER_RUN_ARGS) -e DIST=el7 consul-el7

Dockerfile.el6: Dockerfile
	sed -r 's/centos7/centos6/g' $< > $@

docker-el6: Dockerfile.el6
	docker build \
		--build-arg=CONSUL_VERSION=$(CONSUL_VERSION) \
		--build-arg=CONSUL_TEMPLATE_VERSION=$(CONSUL_TEMPLATE_VERSION) \
		--build-arg=BUILD_NUMBER=$(BUILD_NUMBER) \
		--build-arg=DIST=el6 \
		--build-arg=http_proxy=$(http_proxy) \
		-t consul-el6 -f $< .
	docker run $(DOCKER_RUN_ARGS) -e DIST=el6 consul-el6


-include local.mk
