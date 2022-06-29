#!/bin/bash
#SBATCH -J rbatch
#SBATCH -o rbatch_%j.out
#SBATCH -p development
#SBATCH --mem=4G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

module purge
module load spack
. spack/share/spack/setup-env.sh
spack env activate r-batch

mkdir $HOME/batch_r/
cd $HOME/batch_r/
wget https://raw.githubusercontent.com/jotsap/msds_hpc/main/assignments/batch-test.R

Rscript batch-test.R

cat /proc/cpuinfo
echo "Job ID is $SLURM_JOBID"
echo "Job Name is $SLURM_JOB_NAME"
echo "Cluster Name is $SLURM_CLUSTER_NAME"
echo "Number of nodes is $SLURM_NNODES"
echo "Memory per Node is $SLURM_MEM_PER_NODE"
echo "Memory per CPU is $SLURM_MEM_PER_CPU"
echo "Cores per Node is $SLURM_CPUS_ON_NODE"

