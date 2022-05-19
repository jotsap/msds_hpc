#!/usr/bin/env sh

pull_and_check() {
  name=${1}
  tag=`echo ${name} | cut -d':' -f2`
  docker pull ${name}
  docker image ls | egrep "REPOSITORY|${tag}"
  docker run --rm -it ${name} bash 
}

images[0]="ubuntu:jammy"
images[1]="nvcr.io/nvidia/nvhpc:22.3-devel-cuda_multi-ubuntu20.04"
images[2]="nvcr.io/nvidia/nvhpc:20.7-runtime-cuda10.1-centos7"

for image in ${images[@]}; do
  pull_and_check ${image}
done

