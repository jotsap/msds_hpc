#!/bin/bash
#SBATCH -J assignment_05
#SBATCH -o assignment_05_%j.out
#SBATCH -p htc
#SBATCH --mem=6G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

module purge
module load singularity

cat /proc/cpuinfo
echo "Job ID is $SLURM_JOBID"
echo "Job Name is $SLURM_JOB_NAME"
echo "Cluster Name is $SLURM_CLUSTER_NAME"
echo "Number of nodes is $SLURM_NNODES"
echo "Memory per Node is $SLURM_MEM_PER_NODE"
echo "Memory per CPU is $SLURM_MEM_PER_CPU"
echo "Cores per Node is $SLURM_CPUS_ON_NODE"
