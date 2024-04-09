#!/bin/bash

set -eoux pipefail

cuda_status=$(python3 -c 'import torch; print(torch.cuda.is_available())')

if [[ $cuda_status == "True" ]]; then
    nvidia-smi
    nvcc -V
    runuser -l user -c ./webui.sh --install_dir="/home/$USER" --xformers --listen --port ${EXPOSE_PORT} &
else
    runuser -l user -c ./webui.sh --install_dir="/home/$USER" --skip-torch-cuda-test --precision full --no-half --listen --port ${EXPOSE_PORT} &
fi

exit 0