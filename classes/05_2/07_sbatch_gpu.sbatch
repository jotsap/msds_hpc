#!/bin/bash
#SBATCH -J gpu
#SBATCH -o gpu_%j.out
#SBATCH -p development
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --mem=6G

nvidia-smi

