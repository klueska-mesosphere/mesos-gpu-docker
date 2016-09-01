# Getting Started

Clone this repo on an Nvidia GPU equipped machine with at least 1 GPU
(g2.8xlarge instances will do nicely).

Then run:

    ./build.sh
    ./run.sh
    ./deploy-tasks.sh

This will launch 2 marathon applications. The first application runs
`nvidia-smi` every 60 seconds without a docker container, and the second one
runs `nvidia-smi` every 60 seconds inside an `nvidia/cuda` container.

1. Set up port forwarding in case your are running docker on a remote machine
   and want to browse all of the output locally:

   ssh -NT -L 8080:localhost:8080 -L 5050:localhost:5050 -L 5051:localhost:5051 <remote-ip>

2. Navigate to marathon UI:

    http://<your-ip>:8080

Verify that the tasks are running.

3. Go to the Mesos UI and look at the `stdout` of the tasks:

    http://<your-ip>:5050

4. If they say the following, you've got problems:

    Failed to initialize NVML: Unknown Error

If they print something, like the following, you are good to go:

    +------------------------------------------------------+                       
    | NVIDIA-SMI 352.79     Driver Version: 352.79         |                       
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  Tesla M60           Off  | 0000:04:00.0     Off |                    0 |
    | N/A   31C    P8    14W / 150W |     34MiB /  7679MiB |      0%      Default |
    +-------------------------------+----------------------+----------------------+
                                                                                   
    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID  Type  Process name                               Usage      |
    |=============================================================================|
    |  No running processes found                                                 |
    +-----------------------------------------------------------------------------+
