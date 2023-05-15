#!/bin/bash

## job name and output file
#SBATCH --job-name=go_mesher
#SBATCH -o OUTPUT_FILES/job_mesher-%j.o

###########################################################
# USER PARAMETERS

## 384 CPUs ( 48*8 ), walltime 1 hour
##  Use 48 nodes with 8 tasks each, for 384 MPI tasks:
## (I think nodes*tasks < 32 for Oscar Exploratory account https://ccv.brown.edu/services/rates/)
## nodes=NPROC_XI*NCHUNKS     tasks-per-node=NPROC_XI
## nodes*tasks-per-node must equal NPROC_XI*NPROC_ETA*NCHUNKS
#SBATCH --nodes=12
#SBATCH --tasks-per-node=2
#SBATCH --time=1:00:00

###########################################################
# load correct version of MPI and GCC on Oscar
module load mpi/openmpi_4.0.5_gcc_10.2_slurm20
module load gcc/10.2 cuda/11.1.1

# cd $SLURM_SUBMIT_DIR

BASEMPIDIR=`grep ^LOCAL_PATH DATA/Par_file | cut -d = -f 2 `

# script to run the mesher and the solver
# read DATA/Par_file to get information about the run
# compute total number of nodes needed
NPROC_XI=`grep ^NPROC_XI DATA/Par_file | cut -d = -f 2 `
NPROC_ETA=`grep ^NPROC_ETA DATA/Par_file | cut -d = -f 2`
NCHUNKS=`grep ^NCHUNKS DATA/Par_file | cut -d = -f 2 `
echo $NCHUNKS $NPROC_XI $NPROC_ETA

# total number of nodes is the product of the values read
numnodes=$(( $NCHUNKS * $NPROC_XI * $NPROC_ETA ))
echo $numnodes

mkdir -p OUTPUT_FILES

# backup files used for this simulation
cp DATA/Par_file OUTPUT_FILES/
cp DATA/STATIONS OUTPUT_FILES/
cp DATA/CMTSOLUTION OUTPUT_FILES/

# obtain job information
cat $SLURM_JOB_NODELIST > OUTPUT_FILES/compute_nodes
echo "$SLURM_JOBID" > OUTPUT_FILES/jobid

##
## mesh generation
##
sleep 2

echo
echo `date`
echo "starting MPI mesher on $numnodes processors"
echo

# mpiexec -np $numnodes $PWD/bin/xmeshfem3D
# srun --mpi=pmix --nodes $numnodes $PWD/bin/xmeshfem3D
srun --mpi=pmix $PWD/bin/xmeshfem3D

echo "  mesher done: `date`"
echo

# backup important files addressing.txt and list*.txt
cp OUTPUT_FILES/*.txt $BASEMPIDIR/

echo "finished successfully"
echo `date`
