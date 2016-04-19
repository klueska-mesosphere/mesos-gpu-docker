# Getting Started

Clone this repo on an Nvidia GPU equipped machine with at least 2 GPUs
(g2.8xlarge instances will do nicely).

Then run:

    ./build.sh
    ./run.sh
    ./deploy-task.sh

Navigate to marathon UI:

    http://<your-ip>:8080

Verify that the task is running.

Go to the Mesos UI and look at the `stdout` of the task:

    http://<your-ip>:5050

If it says the following, you've got problems:

    Failed to initialize NVML: Unknown Error

If it prints something, like the following, you are good to go:

    +------------------------------------------------------+                       
    | NVIDIA-SMI 352.79     Driver Version: 352.79         |                       
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  Tesla M60           Off  | 0000:04:00.0     Off |                    0 |
    | N/A   32C    P8    14W / 150W |     34MiB /  7679MiB |      0%      Default |
    +-------------------------------+----------------------+----------------------+
    |   1  Tesla M60           Off  | 0000:05:00.0     Off |                    0 |
    | N/A   32C    P8    13W / 150W |     34MiB /  7679MiB |      0%      Default |
    +-------------------------------+----------------------+----------------------+
    |   2  Tesla M60           Off  | 0000:83:00.0     Off |                    0 |
    | N/A   36C    P8    14W / 150W |     34MiB /  7679MiB |      0%      Default |
    +-------------------------------+----------------------+----------------------+
    |   3  Tesla M60           Off  | 0000:84:00.0     Off |                    0 |
    | N/A   32C    P8    13W / 150W |     34MiB /  7679MiB |      0%      Default |
    +-------------------------------+----------------------+----------------------+
                                                                                   
    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID  Type  Process name                               Usage      |
    |=============================================================================|
    |  No running processes found                                                 |
    +-----------------------------------------------------------------------------+

