SHELL:=bash
# 
# Build docker image
#
#

NAME=jupyter-notebook

VERSION:=1.0

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

JUPYTER_GID:=7000
BUILD_ARGS += --build-arg JUPYTER_GID=$(JUPYTER_GID)

ifdef REGISTRY_URL
REGISTRY_PREFIX=$(REGISTRY_URL)/
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)
endif

BUILDIMAGE=$(NAME):$(VERSION)-$(COMMITID)

all:
	@echo "Usage: make [build|deliver|clean]"

build:
	docker build --rm $(BUILD_ARGS) -t $(BUILDIMAGE) \
		-t $(NAME):latest --cache-from=$(NAME):latest $(DOCKERFILE) .

deliver: tag push

tag:
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):$(VERSION)

push:
	docker push $(REGISTRY_URL)/$(NAME):$(VERSION)
	docker push $(REGISTRY_URL)/$(NAME):latest

clean-all:
	docker rmi -f $(shell docker images $(BUILDIMAGE) -q)

clean:
	 docker rmi $(BUILDIMAGE)

