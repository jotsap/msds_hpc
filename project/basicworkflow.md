### Basic Workflow

* **batch_r.sbatch** is the actual SLURM file that calls the R file **batchtest.R**
* **batchtest.R** which just loads libraries from Spack environment, loads data, cleans it, and writes to a CSV
* **spack_r_final.yaml** is the Spack YAML file for creating the environment

