#!/bin/bash

###Script to check if blueiris.exe is running.  This is a messy way to check if the service needs to be killed.  Docker container must be run with init option to be able to kill PID 1
while :
do
  sleep 15
  pgrep BlueIris >/dev/null && : || kill 1
done
