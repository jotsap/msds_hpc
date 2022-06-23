# Load environment modules
module purge
module load intel-17.0.4
module load cuda/8.0.61-epmoudv arrayfire/3.5.0

# Build executables using make
make all

# Run executables on specific compute nodes
srun -t 2 --reservation=p100 --qos=normal -p gpgpu-1 -n 1 -c 36  --mem=32G ./blas_cpu
srun -t 2 --reservation=knl  --qos=normal -p mic     -n 1 -c 256 --mem=32G ./blas_mic
srun -t 2 --reservation=p100 --qos=normal -p gpgpu-1 -n 1 -c 1   --gres=gpu:1 --mem=32G ./blas_p100

