#!/bin/bash

# Configurable variables
my_address="10.128.0.8"
port=1234
dump_dir="$(pwd)/dump"

# Ensure dump directory exists
mkdir -p "$dump_dir"

# Check if an argument was provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 {counter|reader}"
    exit 1
fi

program=$1

# Validate the input
if [[ "$program" != "counter" && "$program" != "reader" ]]; then
    echo "Invalid argument: must be 'counter' or 'reader'"
    exit 1
fi

# Launch the program in the background
"$HOME/fork/dsm/dsm_test/$program" &
sleep 1  # Give it time to start

# Get the process ID
pid=$(pidof "$program")
if [[ -z "$pid" ]]; then
    echo "Error: Failed to find PID for $program"
    exit 1
fi

cleanup() {
    echo "Cleaning up..."
    sudo kill -9 "$pid" 2>/dev/null
    sudo kill -9 $(pidof criu) 2>/dev/null
    sudo rm dump/*
    exit 1
}

trap cleanup SIGINT

sudo criu dump -t "$pid" -D "$dump_dir" --lazy-pages --address "$my_address" --port "$port" --shell-job &

scp "$HOME/fork/dsm/dsm_test/$program" dsm_client:~/
scp -r "$dump_dir" dsm_client:~/dump

echo "Migration files sent to dsm_client"
echo "waiting for lazy-pages"

wait $!

cleanup
~