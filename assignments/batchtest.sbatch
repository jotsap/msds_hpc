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
module load r/4.0.2
Rscript batch-test.R

cat /proc/cpuinfo
echo "Job ID is $SLURM_JOBID"
echo "Job Name is $SLURM_JOB_NAME"
echo "Cluster Name is $SLURM_CLUSTER_NAME"
echo "Number of nodes is $SLURM_NNODES"
echo "Memory per Node is $SLURM_MEM_PER_NODE"
echo "Memory per CPU is $SLURM_MEM_PER_CPU"
echo "Cores per Node is $SLURM_CPUS_ON_NODE"


##### M2  hpc/exmples/r ######

#!/bin/bash
#SBATCH -J test
#SBATCH -o test_%a-%A.out      #
#SBATCH --array=0-19           # Replace with your range
#SBATCH -p standard-mem-s
#SBATCH --cpus-per-task=18
#SBATCH --mem-per-cpu=7065M

module purge
module load r/3.4.1-1

MODELS=(A1 A4 B1 B4 C1 C4 D1 D4 E1 E4 F1 F4 G1 G4 H1 H4 I1 I4 J1 J4)

R --no-save --no-restore <inst/scripts/stan2.R --args ${MODELS[${SLURM_ARRAY_TASK_ID}]}

##########


#!/bin/bash
#SBATCH -J R_example                   # Job name
#SBATCH -p standard-mem-s              # Partition (queue)
#SBATCH --exclusive                    # Exclusivity
#SBATCH --mem=250G                     # Total memory required per node
#SBATCH -o R_example_%A-%a.out         # Job output; %A is job ID and %a is array index
#SBATCH --array=1-2                    # Range of indices to be executed

module purge                           # Unload all modules
module load R                          # Load R, change version as needed

R --vanilla < array_example_${SLURM_ARRAY_TASK_ID}.R
# Edit R script name as needed; ${SLURM_ARRAY_TASK_ID} is array index


