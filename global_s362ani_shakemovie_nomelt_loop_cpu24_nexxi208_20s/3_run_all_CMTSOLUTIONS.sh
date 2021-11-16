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
    
    # Check whether SAC files have already been output. If so, skip...
    count=`ls -1 ./OUTPUT_FILES/*.sac 2>/dev/null | wc -l`

    if [ $count != 0 ]
    then 
        echo "$evdir/OUTPUT_FILES/ contains SAC files... skip"
    else
        # Run solver
        sbatch 2_go_solver_slurm.sh
    fi 


    cd $workingdir

done


