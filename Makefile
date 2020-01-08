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

BUILDIMAGE=$(NAME):$(VERSION)-$(COMMITID)

all:
	@echo "Usage: make [build|tag|clean|clean-all]"

build:
	docker build --rm $(BUILD_ARGS) -t $(BUILDIMAGE) \
		-t $(NAME):latest --cache-from=$(NAME):latest $(DOCKERFILE) .

deliver: tag push

tag:
	docker tag $(BUILDIMAGE) $(NAME):$(VERSION)

clean-all:
	docker rmi -f $(shell docker images $(BUILDIMAGE) -q)

clean:
	 docker rmi $(BUILDIMAGE)

