#!/usr/bin/env bash

: ${HOSTNAME:="localhost"}
: ${LIBPROCESS_IP:="127.0.0.1"}

if [ "$NUM_GPU_DEVICES" != "" ]; then
    SET_GPU_RESOURCES="-e \"MESOS_RESOURCES=gpus:$NUM_GPU_DEVICES;\""
fi

docker_rm() {
    if [ "$(docker ps --filter "name=$1" -a -q)" != "" ]; then
        docker rm -f "$1"
    fi
}

# Install nvidia-docker and nvidia-docker-plugin
which nvidia-docker > /dev/null 2>&1
RESULT="$?"
if [ "${RESULT}" != "0" ]; then
    wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0-rc.3/nvidia-docker_1.0.0.rc.3_amd64.tar.xz
    sudo tar --strip-components=1 -C /usr/bin -xvf /tmp/nvidia-docker*.tar.xz && rm /tmp/nvidia-docker*.tar.xz
fi

# Run nvidia-docker-plugin
sudo killall nvidia-docker-plugin > /dev/null 2>&1
sudo -b nohup nvidia-docker-plugin > /tmp/nvidia-docker.log 2>&1

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
nvidia-docker run \
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
    marathon
