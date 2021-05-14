#!/bin/bash
# script from Chris Brainerd
#I switched from acrontab to aacrontab

#command is :

#~/bin/resubmitCRABjobs.sh SETUP "$CMSSW_BASE/src"  /afs/cern.ch/user/a/asparker/public/makeTOPnanoAODv6/CMSSW_10_2_18/src/PhysicsTools/NanoAOD/test/tasks3

#where last arg  is your CRAB submit directory



#Takes care of necessary environment setup and such for acron to monitor crab tasks
#To setup: first argument should be SETUP, followed by CMSSW directory (wherever cmsenv should be run)
#Rest should just be directory of crab directories

echo 'Begin script'
OUTPUT="`mktemp -t`"
set -e
exec 3>&1
[ -t 1 ] || exec > "$OUTPUT" # don't redirect if writing to a terminal

(
set -e
if [ "$1" == "SETUP" ]; then
    shift
    #echo 'SETUP'
    #echo "$1"
    #echo "$@" 
#    pushd "$2"
#    if [ $# -le 3 ]; then
#        for dir in crab_*;
#        do
#            touch ${dir}_ND
#        done   
#    fi
#    popd
    if [[ "$@" =~ "%" ]]; then
        echo "No % signs allowed. acrontab will lose its mind over those."
        exit 1
    fi
    if [ -d "$1" ]; then
        #echo 'if whatever'
        rm acrontabCommands.txt
        SERVER=$(hostname)
        echo '48' '*' '*' '*' '*' "$SERVER"  "`readlink -f "$BASH_SOURCE"`" 'SETUP' "$@"
        echo '48' '*' '*' '*' '*' "$SERVER"   "`readlink -f "$BASH_SOURCE"`" 'SETUP' "$@" >> acrontabCommands.txt
        acrontab < acrontabCommands.txt
    else 
        exit 1
    fi
    #echo '27' '*' '*' '*' '*' 'lxplus752.cern.ch' "`readlink -f "$BASH_SOURCE"`" 'SETUP' "$@" >> acrontabCommands.txt
    #acrontab < acrontabCommands.txt
    #exit 0
fi

removeacrontab() {
    echo "Jobs done!"
    echo " " >> nothing.txt
    acrontab < nothing.txt
    #rm ~/".acronJobs/$SHA_SUM"
}

echo 'test'
SHA_SUM="$1"
shift
CMSSW_DIR="$1"
shift
. /cvmfs/cms.cern.ch/cmsset_default.sh
pushd "$CMSSW_DIR"
eval `scramv1 runtime -sh`
echo 'Checking for proxy...'
voms-proxy-info -exists
. /cvmfs/cms.cern.ch/crab3/crab.sh
popd
#echo $CMSSW_DIR
#TASKS_DIR="$2"

#3echo 'Tasks dir'
#echo  $TASKS_DIR

echo "python resubmitCRABjobs.py --loc" $CMSSW_DIR
rm pythoncom.sh
echo "python resubmitCRABjobs.py --loc" $CMSSW_DIR  >> pythoncom.sh
chmod +x pythoncom.sh
cd ~/bin
#python resubmitCRABjobs.py

#cd $2
#
#echo >&3
#exec >&3
echo 'test'
#echo $TASKS_DIR
#echo "python resubmitCRABjobs.py --loc" $TASKS_DIR

stdbuf -o 0 cat "$OUTPUT" | (pythoncom.sh ) 2>&1 

cat "$OUTPUT"
#stdbuf -o 0 cat "$OUTPUT" | (python crabHandle.py "$@" ) 2>&1 | grep -v '^Retrieving' | grep -v '^Success:'
#cat "$OUTPUT"
#rm "$OUTPUT"
) || { echo "Job failed. Bash output is as follows:" ; exec >&3 ; cat "$OUTPUT" ; }

