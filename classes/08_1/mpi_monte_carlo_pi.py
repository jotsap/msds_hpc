import math
import random
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()
print("World size: {}, My Rank: {}".format(size, rank))

pi = 0

if rank == 0:
    for i in range(1, size):
        pi += comm.recv(source=i, tag=i)
    pi = pi / (size-1)
    print(pi)
else:
    count = 100000
    count_inside = 0
    for count in range(0, count):
        d = math.hypot(random.random(), random.random())
        if d < 1:
            count_inside += 1
    pi = (4.0 * count_inside / count)
    comm.send(pi, dest=0, tag=rank)

comm.Barrier()
