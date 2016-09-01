#!/usr/bin/env bash

NATIVE_APP_NAME="/gpu-test"
NATIVE_CONFIG=$(cat << EOF
{
    "id": "${NATIVE_APP_NAME}",
    "cmd": "while [ true ]; do /usr/local/nvidia/bin/nvidia-smi; sleep 60; done",
    "cpus": 0.1,
    "mem": 128.0,
    "gpus": 1,
    "instances": 1,
    "env": {
        "LD_LIBRARY_PATH": "/usr/local/nvidia/lib64:/usr/local/nvidia/lib"
    }
}
EOF
)

DOCKER_APP_NAME="/gpu-test-docker"
DOCKER_CONFIG=$(cat << EOF
{
    "id": "${DOCKER_APP_NAME}",
    "cmd": "while [ true ]; do nvidia-smi; sleep 60; done",
    "cpus": 0.1,
    "mem": 128.0,
    "gpus": 1,
    "instances": 1,
    "container": {
        "type": "MESOS",
        "docker": {
            "image": "nvidia/cuda"
        }
    }
}
EOF
)

if [ "$1" = "--remove" ]; then
	echo "Deleting ${NATIVE_APP_NAME}"
    curl -X DELETE http://localhost:8080/v2/apps/gpu-test
	echo ""
	echo "Deleting ${DOCKER_APP_NAME}"
    curl -X DELETE http://localhost:8080/v2/apps/gpu-test-docker
else
	echo "Creating ${NATIVE_APP_NAME}"
    curl -X POST http://localhost:8080/v2/apps \
         -d @<(echo ${NATIVE_CONFIG}) \
         -H "Content-type: application/json"
	echo ""
	echo "Creating ${DOCKER_APP_NAME}"
    curl -X POST http://localhost:8080/v2/apps \
         -d @<(echo ${DOCKER_CONFIG}) \
         -H "Content-type: application/json"
fi
echo ""
