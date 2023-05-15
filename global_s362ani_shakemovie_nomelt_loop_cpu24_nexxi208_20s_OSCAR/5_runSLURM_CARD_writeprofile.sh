#!/bin/bash
#
## job name and output file
#SBATCH --job-name=go_mesher
#SBATCH -o OUTPUT_FILES/job_mesher-%j.o

###########################################################
# USER PARAMETERS

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --time=10:00:00
###########################################################
# Script to run write_profile for extracting 1-D profiles from the SPECFEM mesh
##################################################
# USER PARAMETER
# source directory
rootdir=/users/jrussel2/data/jrussel2/PROJ_NoMelt/SPECFEM3D-GLOBE/specfem3d_globe-devel-jbr

# load correct version of MPI and GCC on Oscar
module load mpi/openmpi_4.0.5_gcc_10.2_slurm20
module load gcc/10.2 cuda/11.1.1
##################################################

currentdir=`pwd`

# copy executables
cp $rootdir/bin/xwrite_profile ./bin/

#  Usage: xwrite_profile [dlat] [dlon] [lat0] [lon0]
#    with
#       dlat dlon         - (optional) increments for latitude/longitude (in degrees, by default 2x2 degrees)
#       lat0 lon0         - (optional) latitude/longitude (in degrees) for single profile output
$PWD/bin/xwrite_profile 1 1
echo "done: `date`"
