cmake_minimum_required(VERSION 3.8.0)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
project(gemm
  LANGUAGES CXX)

set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-Ofast")

add_executable(gemm gemm.cpp)

find_package(OpenMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(gemm PUBLIC OpenMP::OpenMP_CXX)
endif()

