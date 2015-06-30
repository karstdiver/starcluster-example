from mpi4py import MPI
import random

# comm = MPI.COMM_WORLD
# rank = comm.Get_rank()
rank = 1
# mpisize = comm.Get_size()
# nsamples = int(6e6/mpisize)
nsamples = int(6e6)
nsamples = int(66)

inside = 0
random.seed(rank)
for i in range(nsamples):
    x = random.random()
    y = random.random()
    # print(x,y)
    if (x * x) + (y * y) < 1:
        # print(x*x+y*y)
        print(inside)
        inside += 1

mypi = (4.0 * inside) / nsamples
# pi = comm.reduce(mypi, op=MPI.SUM, root=0)

if rank == 0:
    print (1.0 / mpisize) * pi
