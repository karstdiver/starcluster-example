#!/bin/bash

# Script to demonstrate ec2-cli and starcluster

echo "Start starcluster example script"
uname -a
date

echo "----------------------------------------------"
echo "Show any instances in us-east-1 and us-west-2:"
echo us-east-1;ec2-describe-instance-status --region us-east-1
echo us-west-2;ec2-describe-instance-status --region us-west-2
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Check starcluster:"
starcluster listregions
starcluster listinstances
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Start a cluster:"
time starcluster start mypicluster
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Show running clusters:"
starcluster listclusters
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Show any instances in us-east-1 and us-west-2:"
echo us-east-1;ec2-describe-instance-status --region us-east-1
echo us-west-2;ec2-describe-instance-status --region us-west-2
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Put pi.py file onto cluster:"
starcluster put mypicluster pi-python/pi.sh /home/sgeadmin
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Run Monte Carlo method pi.py on cluster using MPI:"
starcluster sshmaster mypicluster -u sgeadmin <<EOF
rm pi.o* pi.po* STDIN.*;qstat -g c;qsub ./pi.sh;sleep 2;qstat -g c;sleep 30;cat pi.o* STDIN.*;exit
EOF
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Terminate cluster:"
#time starcluster terminate mypicluster
echo "----------------------------------------------"

echo "----------------------------------------------"
echo "Show any instances in us-east-1 and us-west-2:"
echo us-east-1;ec2-describe-instance-status --region us-east-1
echo us-west-2;ec2-describe-instance-status --region us-west-2
echo "----------------------------------------------"

echo "End of startcluster example script"
date
exit
