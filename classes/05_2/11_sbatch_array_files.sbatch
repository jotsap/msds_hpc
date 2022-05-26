#!/bin/bash
#SBATCH -J data
#SBATCH -o data_import_%A-%a.out
#SBATCH --array=0-2492              # Loops over all XML files
#SBATCH -p htc
#SBATCH --mem=6G
#SBATCH --cpus-per-task=1

# Load Python3
module purge
module load python

# Builds array of all original XML files, which are read-only
data_dir="$WORK/data/original_xml/"
readarray xml_files < <(ls ${data_dir}*.xml | sort)
f=${xml_files[${SLURM_ARRAY_TASK_ID}]}
fb=$(basename ${f} .xml)

# Converts XML to TSV and SQLite3 files
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
python3 data_import.py ${f} ${fb}

