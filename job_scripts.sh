#!/bin/bash -l
#PBS -N nchat_scale
#PBS -l select=1:ncpus=32
#PBS -l walltime=20:00:00
#PBS -q preemptable
#PBS -A argonne_tpc
#PBS -l filesystems=home:eagle

source ~/.bashrc
cd /home/abalaji/projects/modcon/tools/nanochat
source .venv/bin/activate
export NANOCHAT_BASE_DIR="/lus/eagle/projects/argonne_tpc/abalaji/.cache/nanochat"

PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True WANDB_RUN=nanochat-train-scale torchrun --standalone --nproc_per_node=4 -m scripts.base_train -- --run=$WANDB_RUN
