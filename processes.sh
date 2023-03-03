#!/bin/bash

process_watcher() {
  declare -A process_list

  while true; do
    newprocs=0
    # Get the list of processes
    running_procs=$(ps -eo pid,comm --no-headers)
    # Loop through the list of processes and check if each process is new
    while read -r process; do
      # Extract the process ID and command
      process_id=$(echo "$process" | awk '{print $1}')
      command=$(echo "$process" | awk '{print $2}')
      if ! [[ "${process_list[$process_id]}" ]]; then
        # Adds new processes to the process list
        process_list[$process_id]=$command
        echo "PID: $process_id - Command: $command" >> processes.txt
        newprocs=$((newprocs+1))
      fi
    done <<< "$running_procs"
    echo "There were $((newprocs-1)) new processes spawned in the past 30 seconds"
    sleep 30
  done
}

# Start the process watcher in the background
process_watcher 
