from numba import njit, prange
import numpy as np

@njit(parallel=True, fastmath=True)
def two_d_array_reduction_prod(n):
    shp = (5000, 5000)
    result1 = 2 * np.ones(shp, np.int_)
    tmp = 2 * np.ones_like(result1)

    for i in prange(n):
        result1 *= tmp

    return result1

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('-n', type=int, default=1)
    args = parser.parse_args()

    two_d_array_reduction_prod(args.n)
