import time, random

def initialize_matrix(m, n, fill=0):
    matrix = []
    for i in range(m):
        row = []
        for j in range(n):
            if fill == 0:
                f = 0
            else:
                f = random.random()
            row.append(f)
        matrix.append(row)
    return matrix

def gemm(matrix_a, matrix_b):
    m = len(matrix_a[:][0])
    n = len(matrix_b[:][0])
    p = len(matrix_a[0][:])
    matrix_c = initialize_matrix(m, p)
    for i in range(m):
        for j in range(p):
            for k in range(n):
                matrix_c[i][j] += matrix_a[i][k]*matrix_b[k][j]
    return matrix_c

def py_gemm(i):
    start = time.time_ns()
    matrix_a = initialize_matrix(i, i, fill=1)
    matrix_b = initialize_matrix(i, i, fill=1)
    matrix_c = gemm(matrix_a, matrix_b)
    stop = time.time_ns()
    return stop - start

if __name__ == '__main__':
    i = 512
    dt = py_gemm(i)
    print("Matrix of size {} by {} completed in {} μs.".format(i, i, dt / 1000))

