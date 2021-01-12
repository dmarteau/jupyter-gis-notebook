SHELL:=bash
# 
# Build docker image
#
#

NAME=jupyter-notebook

VERSION:=1.0

JUPYTER_GID:=$(shell id -u)
BUILD_ARGS += --build-arg JUPYTER_GID=$(JUPYTER_GID)

build:
	docker build --rm $(BUILD_ARGS) \
		-t $(NAME):$(VERSION) \
		-t $(NAME):latest --cache-from=$(NAME):latest $(DOCKERFILE) .

clean-all:
	docker rmi -f $(shell docker images $(NAME):latest -q)

