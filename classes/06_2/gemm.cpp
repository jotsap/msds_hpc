#include <iostream>
#include <iomanip>
#include <vector>
#include <random>
#include <chrono>
#include <armadillo>

typedef std::vector<std::vector<double>> matrix;

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

matrix gemm(const matrix matrix_a, const matrix matrix_b) {
    auto m = matrix_a.size();
    auto n = matrix_b.size();
    auto p = matrix_a.front().size();
    matrix matrix_c = initialize_matrix(m, p);
    for (uint64_t i = 0; i < m; ++i) {
        for (uint64_t j = 0; j < p; ++j) {
            for (uint64_t k = 0; k < n; ++k) {
                matrix_c[i][j] += matrix_a[i][k]*matrix_b[k][j];
            }
        }
    }
    return matrix_c;
}

int64_t cpp_gemm(const uint64_t i) {
    auto start = std::chrono::system_clock::now();
    auto matrix_a = initialize_matrix(i, i, false);
    auto matrix_b = initialize_matrix(i, i, false);
    auto matrix_c = gemm(matrix_a, matrix_b);
    auto stop = std::chrono::system_clock::now();
    return std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();
}

int64_t arma_gemm(const uint64_t i) {
    auto start = std::chrono::system_clock::now();
    arma::mat matrix_a(i, i, arma::fill::randu);
    arma::mat matrix_b(i, i, arma::fill::randu);
    arma::mat matrix_c(i, i, arma::fill::zeros);
    matrix_c = matrix_a*matrix_b;
    auto stop = std::chrono::system_clock::now();
    return std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();
}

void compare_gemm() {
    for (auto& i : {512, 1024}) {
        auto cpp_dt = cpp_gemm(i);
        auto arma_dt = arma_gemm(i);
        auto cblas_dt = cblas_gemm(i);
        std::cout << std::fixed << std::setprecision(1)
                  << "Size: " << i
                  << ", Speed-up: " << static_cast<double>(cpp_dt) / static_cast<double>(arma_dt)
                  << ", Language: " << cpp_dt
                  << ", Library: " << arma_dt << std::endl;
    }
}

int main() {
    compare_gemm();
    return 0;
}

