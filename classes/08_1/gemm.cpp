#include <iostream>
#include <iomanip>
#include <vector>
#include <random>
#include <chrono>

// Define matrix type from nested vectors
typedef std::vector<std::vector<double>> matrix;

// Initialize matrix with random values or zeros
matrix initialize_matrix(const uint64_t m, const uint64_t n, const bool fill=true) {
    matrix mat;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);
    for (uint64_t i = 0; i < m; ++i) {
        std::vector<double> row;
        for (uint64_t j = 0; j < n; ++j) {
            fill ? row.push_back(0) : row.push_back(dis(gen));
        }
        mat.push_back(row);
    }
    return mat;
}

// Naive implementation of matrix multiplication
matrix gemm(const matrix matrix_a, const matrix matrix_b) {
    auto m = matrix_a.size();
    auto n = matrix_b.size();
    auto p = matrix_a.front().size();
    matrix matrix_c = initialize_matrix(m, p);
    #pragma omp parallel for
    for (uint64_t i = 0; i < m; ++i) {
        for (uint64_t j = 0; j < p; ++j) {
            for (uint64_t k = 0; k < n; ++k) {
                matrix_c[i][j] += matrix_a[i][k]*matrix_b[k][j];
            }
        }
    }
    return matrix_c;
}

int main() {
    uint64_t i = 512;
    auto matrix_a = initialize_matrix(i, i, false);
    auto matrix_b = initialize_matrix(i, i, false);

    auto start    = std::chrono::system_clock::now();
    auto matrix_c = gemm(matrix_a, matrix_b);
    auto stop     = std::chrono::system_clock::now();

    auto dt       = std::chrono::duration_cast<std::chrono::microseconds>(stop - start).count();
    std::cout << std::fixed << std::setprecision(1)
              << "Matrix of size " << i << " by " << i
              << " completed in " << dt << " μs." << std::endl;
    
    return 0;
}
