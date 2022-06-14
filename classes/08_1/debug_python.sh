#!/usr/bin/env zsh

# Run Python script
python3 gemm.py

# Run GEMM script through debugger
python3 -m pdb gemm.py

# Distributed debugging, requires X11
source ~/.venv/mpi4py/bin/activate
mpirun -n 2 xterm -e python3 -m pdb ./mpi_monte_carlo_pi.py

