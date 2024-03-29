#!/bin/bash
#
# global simulation example
#
# script runs mesher and solver
# using batch scripts for a PBS queueing system
# on 384 MPI processes
#
#
# modify accordingly for your own system specifics
##################################################
# USER PARAMETER
# source directory
#rootdir=/users/jrussel2/data/jrussel2/PROJ_NoMelt/SPECFEM3D-GLOBE/specfem3d_globe-devel-jbr
rootdir=/home/jbrussel/testdir/specfem3d_globe

# load correct version of MPI and GCC on Oscar
#module load mpi/openmpi_4.0.5_gcc_10.2_slurm20
#module load gcc/10.2 cuda/11.1.1
##################################################

echo "running example: `date`"
currentdir=`pwd`

echo "directory: $currentdir"
echo

# sets up directory structure in current example directoy
echo
echo "   setting up example..."
echo

mkdir -p DATABASES_MPI
mkdir -p OUTPUT_FILES

rm -rf DATABASES_MPI/*
rm -rf OUTPUT_FILES/*

# compiles executables in root directory
# using default configuration

cd $rootdir
# Configure
./configure --enable-openmp FC=gfortran CC=gcc MPIFC=mpif90
# compiles for a forward simulation
cp $currentdir/DATA/Par_file DATA/Par_file
make clean
make all

# backup of constants setup
cp setup/* $currentdir/OUTPUT_FILES/
cp DATA/Par_file $currentdir/OUTPUT_FILES/

cd $currentdir

# copy executables
mkdir -p bin
cp $rootdir/bin/xmeshfem3D ./bin/
cp $rootdir/bin/xspecfem3D ./bin/

# links data directories needed to run example in this current directory with s362ani
cd DATA/
ln -s $rootdir/DATA/crust2.0
ln -s $rootdir/DATA/s362ani
ln -s $rootdir/DATA/QRFSI12
ln -s $rootdir/DATA/topo_bathy
cd ../

# submits job to run mesher & solver
echo
echo "  submitting script..."
echo

echo "please submit job now manually: "
echo "  meshing            : qsub go_mesher_pbs.bash"
echo "  forward simulation : qsub go_solver_pbs.bash"
echo
echo "after job completion, see results in directory: OUTPUT_FILES/"
echo "done: `date`"

