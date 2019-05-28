#!/bin/bash
set -e
export MYVERSION="$RANDOM"
j2 kong-monitoring.yml.j2 -o kong-monitoring.yml
./run.sh monitoring
sleep 5
curl -s http://localhost:8000/version | grep "$MYVERSION"
echo EXITCODE is $?
