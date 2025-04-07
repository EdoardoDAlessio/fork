#!/bin/bash


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

# Clean up - kill the process specified by PID
echo "Killing hanging process $program"
sudo kill -9 $(pidof "$program")

# Clean up - kill CRIU-related processes
echo "Killing hangin CRIU processes"
sudo kill -9 $(pidof criu)

# Clean up - remove all files in the dump directory
echo "Removing files in dump/ directory"
sudo rm -rf dump/*

echo "Cleanup completed."