CXX = icpc
OPT = -O3
EXE = blas_cpu blas_mic blas_p100

all : $(EXE)

blas_cpu : blas.cpp
	$(CXX) $(OPT) -xCORE-AVX2 $^ -o $@ -lafcpu

blas_mic : blas.cpp
	$(CXX) $(OPT) -xMIC-AVX512 $^ -o $@ -lafcpu

blas_p100 : blas.cpp
	$(CXX) $(OPT) -xCORE-AVX2 $^ -o $@ -lafcuda

clean :
	rm -rf $(EXE)

