#!/bin/bash
#SBATCH -J mpi
#SBATCH -o mpi.out
#SBATCH -p development
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=6G
#SBATCH --exclude=k001

# Build executable ahead of job submission
# module purge
# module load intel/oneAPI-2021
# mpicc -fopenmp -o mpi_get_hostnames_hybrid mpi_get_hostnames_hybrid.c

# Setup environment
module purge
module load intel/oneAPI-2021
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

# Run executable
srun mpi_get_hostnames_hybrid

