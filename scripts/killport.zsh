#!/bin/zsh

# Script to kill processes listening on a specified port

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <port_number>"
  exit 1
fi

PORT=$1

# Find process IDs listening on the specified port
PIDs=$(lsof -ti :$PORT)

if [[ -z "$PIDs" ]]; then
  echo "No processes found listening on port $PORT"
  exit 0
fi

# Kill the processes
echo "Killing processes listening on port $PORT: $PIDs"
for pid in ${(f)PIDs}; do
  kill -9 $pid
done
echo "Done"