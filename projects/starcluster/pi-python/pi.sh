
# Adapted from
#   http://www.admin-magazine.com/HPC/Articles/StarCluster-Toolkit-Virtualization-Meets-HPC

# nano pi.sh
# qsub pi.sh

#!/bin/sh
# Export all environment variables
#$ -V
# Your job name
#$ -N pi
# Use current working directory
#$ -cwd
# Join stdout and stderr
#$ -j y
# PARALLEL ENVIRONMENT:
#$ -pe orte 2
# Enable resource reservation
#$ -R y
# The max hard walltime for this job is 16 minutes (after this it will be killed)
#$ -l h_rt=00:16:00
# The max soft walltime for this job is 15 minute (after this SIGUSR2 will be sent)
#$ -l s_rt=00:15:00
echo "Got $NSLOTS processors."
# The mpirun command.
#mpirun -np $NSLOTS python pi.py
mpirun -np $NSLOTS python << EOF
# pi by Monte Carlo Method
# If a circle of radius R is inscribed inside a square with side length 2R, 
# then the area of the circle will be pi*R^2 and the area of the square will 
# be (2R)^2. So the ratio of the area of the circle to the area of the square will be pi/4.
#
# This means that, if you pick N points at random inside the square, approximately 
# N*pi/4 of those points should fall inside the circle.
#
# This program picks points at random inside the square. It then checks to see 
# if the point is inside the circle 
# (it knows it's inside the circle if x^2 + y^2 < R^2, where x and y are the 
# coordinates of the point and R is the radius of the circle). 
# The program keeps track of how many points it's picked so far (N) and how 
# many of those points fell inside the circle (M).
#
# Pi is then approximated as follows:
#
#     4*M
# pi = ---
#      N
#
# For example, consider a circle inscribed in a unit square. 
# 
# Given that the circle and the square have a ratio of areas that is  /4, 
# the value of   can be approximated using a Monte Carlo method:
#   1. Draw a square on the ground, then inscribe a circle within it.
#   2. Uniformly scatter some objects of uniform size (grains of rice or sand) over the square.
#   3. Count the number of objects inside the circle and the total number of objects.
#   4. The ratio of the two counts is an estimate of the ratio of the two areas, 
# which is  /4. Multiply the result by 4 to estimate  .
# 
# In this procedure the domain of inputs is the square that circumscribes our circle. 
# We generate random inputs by scattering grains over the square then perform a computation 
# on each input (test whether it falls within the circle). Finally, we aggregate the 
# results to obtain our final result, the approximation of  .
# 

from mpi4py import MPI
import random

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
mpisize = comm.Get_size()
nsamples = int(6e6/mpisize)

inside = 0
random.seed(rank)
for i in range(nsamples):
    x = random.random()
    y = random.random()
    if (x*x)+(y*y)<1:
        inside += 1

mypi = (4.0 * inside)/nsamples
pi = comm.reduce(mypi, op=MPI.SUM, root=0)

if rank==0:
    print (1.0 / mpisize)*pi
EOF
