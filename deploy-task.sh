#!/usr/bin/env bash

CONFIG=$(cat << EOF
{
    "id": "gpu-test", 
    "cmd": "nvidia-smi; sleep 60;",
    "cpus": 0.1,
    "mem": 128.0,
    "gpus": 2,
    "instances": 1
}
EOF
)

if [ "$1" = "--remove" ]; then
    curl -X DELETE http://localhost:8080/v2/apps/test-gpus
else
    curl -X POST http://localhost:8080/v2/apps \
         -d @<(echo ${CONFIG}) \
         -H "Content-type: application/json"
fi
echo ""
