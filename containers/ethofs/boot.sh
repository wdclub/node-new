#!/bin/sh

shutdown() {
  echo "shutting down container"

  # first shutdown any service started by runit
  for _srv in $(ls -1 /home/etho/service); do
    sv force-stop $_srv
  done

  # shutdown runsvdir command
  kill -HUP $RUNSVDIR
  wait $RUNSVDIR

  # give processes time to stop
  sleep 0.5

  # kill any other processes still running in the container
  for _pid  in $(ps -eo pid | grep -v PID  | tr -d ' ' | grep -v '^1$' | head -n -6); do
    timeout -t 30 /bin/sh -c "kill $_pid && wait $_pid || kill -9 $_pid"
  done
  exit
}

# store enviroment variables
export > /home/etho/envvars

_maxstorage="16GB"
ipfs config Datastore.StorageMax $_maxstorage
ipfs config --json Swarm.ConnMgr.LowWater 400
ipfs config --json Swarm.ConnMgr.HighWater 600

if [ ! -f "./.ipfs/ipfs_initialized" ]; then
  ./init-ipfs.sh
  touch "./.ipfs/ipfs_initialized"
fi

PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin

# run all scripts in the run_once folder
# /bin/run-parts ~/run_once

exec env - PATH=$PATH runsvdir -P /home/etho/service &

RUNSVDIR=$!
echo "Started runsvdir, PID is $RUNSVDIR"
echo "wait for processes to start...."

sleep 5
for _srv in $(ls -1 /home/etho/service); do
    sv status $_srv
done

# catch shutdown signals
trap shutdown TERM HUP QUIT INT
wait $RUNSVDIR

shutdown