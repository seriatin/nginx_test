#!/bin/bash

banner() {
    echo "+------------------------------------------------------------------------+"
    printf "| %-70s |\n" "`date`"
    echo "|                                                                        |"
    printf "| %-70s |\n" "$@"
    echo "+------------------------------------------------------------------------+"
}

one_banner() {
    printf " %-70s \n" "`date` $@"
}

VM_WORKER=$1
VM_BYTES=$2
BACKOFF=${3:-10000}
TIMEOUT=${4:-600}

banner "Start StressTest ... [MEMORY]"

stress-ng --vm $VM_WORKER --vm-bytes $VM_BYTES --backoff $BACKOFF --timeout $TIMEOUT --metrics -v &

JOBID=$!

while kill -0 "$JOBID"; do
    one_banner "Running StressTest ... [MEMORY Usage - $(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{print 100-100*a/t"%"}' /proc/meminfo)]"
    sleep 1

done

banner "Stop StressTest ... [MEMORY]"


while true
do
    one_banner "Wait Scale-in ..."
    sleep 10
done
