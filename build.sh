#!/usr/bin/env bash

set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=${CURRENT_DIR}/build
BIN_DIR=${BUILD_DIR}/bin

rm -rf ${BUILD_DIR}
mkdir -p ${BIN_DIR}

: ${IMAGES:="mesos-base
             mesos-build
             mesos-update
             mesos-master
             mesos-agent
             marathon-base
             marathon-build
             marathon-update
             marathon
             zookeeper"}

# Build the images
for image in ${IMAGES}; do
    docker build \
        -t ${image} \
        -f Dockerfile.${image} \
        .
done

# Install the latest nvidia-docker and nvidia-docker-plugin
wget -P ${BUILD_DIR} https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0-rc.3/nvidia-docker_1.0.0.rc.3_amd64.tar.xz
tar --strip-components=1 -C ${BIN_DIR} -xvf ${BUILD_DIR}/nvidia-docker*.tar.xz
