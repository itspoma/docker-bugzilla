CONTAINER_NAME = bugzilla
IMAGE_NAME = ${CONTAINER_NAME}/image

HOME = /shared
PORT = 80

.PHONY: all

help:
	@echo " all \t\t to run all on production (port 80)"
	@echo " clean \t\t to clean project-related containers & images"
	@echo " clean-all \t to clean all Docker containers & images"
	@echo " ssh \t\t to ssh into Docker containers"

all: up clean build run

up:
	git pull --force || true

clean: clean-image clean-container

clean-all: clean
	docker rm -f $$(docker ps -aq) || true
	docker ps -a

clean-image:
	docker rmi -f ${IMAGE_NAME} 2>/dev/null || true
	docker images | grep ${IMAGE_NAME} || true

clean-container:
	docker rm -f ${CONTAINER_NAME} 2>/dev/null || true
	docker ps -a

build: stop clean-container
	docker build -t ${IMAGE_NAME} .

stop: clean-container

run: stop
	docker run --name=${CONTAINER_NAME} \
		-p ${PORT}:8080 \
		-v $$PWD:${HOME} \
		-ti -d ${IMAGE_NAME}

ssh:
	docker exec -ti ${CONTAINER_NAME} bash
