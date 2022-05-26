#!/bin/bash
#SBATCH -J mpi
#SBATCH -o mpi_%j.out
#SBATCH -p development
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=6G

# Build executable ahead of job submission
# module purge
# module load intel/oneAPI-2021
# mpicc -o mpi_get_hostnames mpi_get_hostnames.c

# Setup environment
module purge
module load intel/oneAPI-2021

# Run executable
srun mpi_get_hostnames

