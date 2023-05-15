#!/bin/bash

#SBATCH --time=5-00:00:00
#SBATCH --mem=5G
#SBATCH -n 2

# Run a command
export PYTHONUNBUFFERED=TRUE
python 2_setup_dirs_for_loop.py
