#!/usr/bin/env bash

set -e

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
