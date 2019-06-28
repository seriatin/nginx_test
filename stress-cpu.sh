#!/bin/bash

banner() {
    echo "+------------------------------------------------------------------------+"
    printf "| %-70s |\n" "`date`"
    echo "|                                                                        |"
    printf "|`tput bold` %-70s `tput sgr0`|\n" "$@"
    echo "+------------------------------------------------------------------------+"
}

one_banner() {
    printf "`tput bold` %-70s `tput sgr0`\n" "`date` $@"
}

CPU_CORE=$1
CPU_LOAD=$2
BACKOFF=${3:-10000}
TIMEOUT=${4:-600}

banner "Start StressTest ... [CPU]"

stress-ng --cpu $CPU_CORE --cpu-load $CPU_LOAD --backoff $BACKOFF --timeout $TIMEOUT --metrics -v &

JOBID=$!

while kill -0 "$JOBID"; do
    one_banner "Running StressTest ... [CPU Usage $((grep 'cpu ' /proc/stat;sleep 0.1;grep 'cpu ' /proc/stat)|awk -v RS="" '{print ""($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)"%"}')]"
    sleep 1

done

banner "Stop StressTest ... [CPU]"


while true
do
    one_banner "Wait Scale-in ..."
    sleep 10
done
