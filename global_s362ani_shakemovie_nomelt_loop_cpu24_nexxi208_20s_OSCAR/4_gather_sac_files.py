# Script to search through all directories in ./runs and copy them to ./EVENTS_sac directory and format the file names correctly.

import os
import glob

# %% codecell
path2runs = './runs/'
path2sac = './SAC_20s/'
comp_pref = 'BH'

if not os.path.exists(path2sac):
    os.system('mkdir '+path2sac)

# %% codecell
# Loop through all CMTSOLUTION files and create the SPECFEM directory
for evt in os.scandir(path2runs):
    evid = evt.name
    print(evid)
    
    path2sac_evt = path2sac+'/'+evid
    if not os.path.exists(path2sac_evt):
        os.system('mkdir '+path2sac_evt)
    
    path2sac_specfem = evt.path+'/OUTPUT_FILES/*.sac'
    listing = glob.glob(path2sac_specfem)
    for sta in listing:
        tokspath = sta.split('/')
        filename = tokspath[-1]
        toks = filename.split('.')
        network = toks[0]
        stnm = toks[1]
        comp = toks[2][-1]
        outfilename = path2sac_evt+'/' + evid+'.'+network+'.'+stnm+'.'+comp_pref+comp+'.sac'
        print(outfilename)
        os.system('cp '+sta+' '+outfilename)



