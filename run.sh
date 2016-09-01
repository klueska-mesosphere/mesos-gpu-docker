#!/usr/bin/env bash

: ${HOSTNAME:="localhost"}
: ${LIBPROCESS_IP:="127.0.0.1"}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=${CURRENT_DIR}/build
BIN_DIR=${BUILD_DIR}/bin

if [ "$NUM_GPU_DEVICES" != "" ]; then
    SET_GPU_RESOURCES="-e \"MESOS_RESOURCES=gpus:$NUM_GPU_DEVICES;\""
fi

docker_rm() {
    if [ "$(docker ps --filter "name=$1" -a -q)" != "" ]; then
        docker rm -f "$1"
    fi
}

# Run nvidia-docker-plugin
sudo killall nvidia-docker-plugin > /dev/null 2>&1
sudo -b nohup ${BIN_DIR}/nvidia-docker-plugin > ${BUILD_DIR}/nvidia-docker.log 2>&1

# Run zookeeper
docker_rm zookeeper
docker run \
    -d \
    -p 2181:2181 \
    --net="host" \
    --name zookeeper \
    zookeeper

# Run the Mesos master
docker_rm mesos-master
docker run \
    -d \
    -p 5050:5050 \
    --net="host" \
    -e "LIBPROCESS_IP=$LIBPROCESS_IP" \
    --name mesos-master \
    mesos-master

# Run the Mesos agent
docker_rm mesos-agent
${BIN_DIR}/nvidia-docker run \
    -d \
    -p 5051:5051 \
    --net="host" \
    -e "LIBPROCESS_IP=$LIBPROCESS_IP" \
	$SET_GPU_RESOURCES \
    -e "MESOS_CGROUPS_HIERARCHY=/sys/fs/cgroup/docker" \
    -v /sys/fs/cgroup/docker \
    --privileged \
    --name mesos-agent \
    mesos-agent

# Run Marathon
docker_rm marathon
docker run \
    -d \
    -p 8080:8080 \
    -p 60035:60035 \
    --net="host" \
    -e "LIBPROCESS_IP=$LIBPROCESS_IP" \
    -e "MARATHON_HOSTNAME=$HOSTNAME" \
    --name marathon \
    marathon --enable_features "gpu_resources"
