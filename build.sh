#!/bin/bash
#initalize docker buildx
docker buildx create --name builder --use
docker buildx inspect --bootstrap
#build and push project
docker buildx build \
--platform=linux/amd64,linux/arm64 \
--push \
--tag zzebrahz/docker-whmcs \
.