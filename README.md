# acrontabCRABresubmission
This repo is to store the code to run acrontab jobs on LxPlus in order to automatically resubmit CRAB jobs whose CRAB directories are in the specified folder

cd to some CMSSW_BASE
cmsenv
voms-proxy-init --voms cms --valid 192:00 

./resubmitCRABjobs.sh SETUP "$CMSSW_BASE/src" /afs/cern.ch/user/a/asparker/public/makeTOPnanoAODv6/CMSSW_10_2_18/src/PhysicsTools/NanoAOD/test/tasks4
