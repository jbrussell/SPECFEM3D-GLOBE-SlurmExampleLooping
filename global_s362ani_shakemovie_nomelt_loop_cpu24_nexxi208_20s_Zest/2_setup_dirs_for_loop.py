# Script to loop through all CMTSOLUTIONS files and make the relevant SPECFEM directory.
# Must first run the initializaiton scripts to build binaries and run the mesher
# init_0_run_this_example.sh - compiles binaries and copies relevant files
# init_1_go_mesher_slurm.sh - runs the mesher
#

import os

# %% codecell
path2eventmat = './eventmat/'
path2CMTSOLUTION = './CMTSOLUTIONS/'
path2runs = './runs/'
path2scripts = './shell_scripts/'

if not os.path.exists(path2runs):
    os.system('mkdir '+path2runs)

# %% codecell
# Loop through all CMTSOLUTION files and create the SPECFEM directory
for entry in os.scandir(path2eventmat):
    evid = entry.name.split('_')[0]
    print(evid)
    
    if not os.path.exists(path2CMTSOLUTION+'/'+evid+'_CMTSOLUTION'):
        print('Could not find CMTSOLUTION file for '+evid+'... skipping')
        continue

    path2evt = path2runs + '/' + evid +'/'
    if not os.path.exists(path2evt):
        os.system('mkdir '+path2evt)
 
    # Copy DATA directory
    os.system('cp -r ./DATA ' + path2evt)
    # Copy OUTPUT_FILES directory
    os.system('cp -r ./OUTPUT_FILES ' + path2evt)
    # Copy DATABASES_MPI directory
    os.system('cp -r ./DATABASES_MPI ' + path2evt)
    # Copy bin directory
    os.system('cp -r ./bin ' + path2evt)
    # Copy CMTSOLUTION
    os.system('cp ' + path2CMTSOLUTION+'/'+evid+'_CMTSOLUTION ' + path2evt + '/DATA/CMTSOLUTION')
    # Copy scripts
    os.system('cp ' + path2scripts+'/*.sh ' + path2evt)
