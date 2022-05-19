#!/usr/bin/env sh

# Create builder to build images
docker buildx create --name builder --use

# Build images for x86_64 and ARM64
docker buildx build --platform\
 linux/amd64,linux/arm64 -t rkalescky/python3:latest\
 -f python3.dockerfile --push .

# Inspect the built images
docker buildx imagetools inspect rkalescky/python3:latest

