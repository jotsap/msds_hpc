#!/usr/bin/env zsh

# Setup build directory
mkdir build
cd build

# Build GEMM executable
cmake -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release ..
make

# Run GEMM executable
./gemm

# Turn on debug flag and rebuild
cmake -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug ..
make

# Run GEMM exectuable through debugger
# Several to choose from depending on compiler
# GDB, LLDB are the most common
lldb ./gemm

# Distributed debugging, requires X11
mpic++ -g -o mpi_monte_carlo_pi mpi_monte_carlo_pi.cpp
mpirun -n 2 xterm -e lldb ./mpi_monte_carlo_pi 1000

