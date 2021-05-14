# MakeGFAL-COPYTxtFiles 

# Get grid proxy first
#voms-proxy-init --voms cms

## Use this python file to make any gfal-copy file you want
# Options
# File location
# Txt File name
import argparse , os

# set up an argument parser                                                                                                                                                                         
parser = argparse.ArgumentParser()

parser.add_argument('--loc', dest = 'LOC', default= '/afs/cern.ch/user/a/asparker/public/makeTOPnanoAODv6/CMSSW_10_2_18/src/PhysicsTools/NanoAOD/test/tasks3')
parser.add_argument('--name', dest='NAME', default=None)# used to name txt file and eos directory 
parser.add_argument('--v', dest='VERBOSE', default=True)


ARGS = parser.parse_args()


lstxt = "ls "  + ARGS.LOC

# Find all subdirectories and write CRAB resubmit commands for them
print lstxt

#commandList = []
for fn in filter(None,os.popen( lstxt  ).read().split('\n')):

    if 'txt' in fn : continue
    if 'pkl' in fn : continue 
    #commandList.append( "crab resubmit "+ fn )
    os.system( "crab resubmit " + ARGS.LOC + '/'+ fn  )
    os.system( "echo crab resubmit " + ARGS.LOC + '/'+ fn  )
    if ARGS.VERBOSE :  print "Running command :  {}".format( "crab resubmit " + ARGS.LOC + '/'+ fn   )

