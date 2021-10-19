#!/bin/bash
##################################################
# load correct version of MPI and GCC on Oscar
module load mpi/openmpi_4.0.5_gcc_10.2_slurm20
module load gcc/10.2 cuda/11.1.1
##################################################
workingdir=`pwd`
echo $workingdir

COUNTER=0
for evdir in ./runs/*/ ; do
    COUNTER=$[COUNTER + 1]
    
    echo "$evdir"
    cd $evdir

    # Run solver
    sbatch 2_go_solver_slurm.sh

    cd $workingdir

done


