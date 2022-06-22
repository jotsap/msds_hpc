#!/bin/bash
#SBATCH -J batchtest
#SBATCH -o batchtest_%j.out
#SBATCH -p htc
#SBATCH --mem=6G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

mkdir $WORK/batchtest/
cd $WORK/batchtest/
wget https://raw.githubusercontent.com/jotsap/msds_hpc/main/assignments/batch-test.R

module purge
module load r-base
Rscript batch-test.R

cat /proc/cpuinfo
echo "Job ID is $SLURM_JOBID"
echo "Job Name is $SLURM_JOB_NAME"
echo "Cluster Name is $SLURM_CLUSTER_NAME"
echo "Number of nodes is $SLURM_NNODES"
echo "Memory per Node is $SLURM_MEM_PER_NODE"
echo "Memory per CPU is $SLURM_MEM_PER_CPU"
echo "Cores per Node is $SLURM_CPUS_ON_NODE"
