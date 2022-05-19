#!/usr/bin/env sh

# Build image using multi-stage Dockerfile
docker build -t hello:20.04 -f hello_world.dockerfile .

# Run the image
docker run hello:20.04

# Note the size difference
docker image ls | egrep "hello|22.3-devel"

