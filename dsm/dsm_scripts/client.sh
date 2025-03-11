#!/bin/bash

# Configurable variables
src_address="10.128.0.8"
port=1234
dump_dir="$(pwd)/dump"
lazy_page_pid=0

# Ensure dump directory exists
mkdir -p "$dump_dir"

cleanup() {
    echo "Cleaning up..."
    if [ "$lazy_page_pid" -ne 0 ]; then
        sudo kill -9 "$lazy_page_pid" 2>/dev/null
    fi
    sudo kill -9 $(pidof criu) 2>/dev/null
    sudo kill -9 $(pidof counter) 2>/dev/null
    sudo kill -9 $(pidof reader) 2>/dev/null
    sudo rm -rf "$dump_dir"/*
    exit 1
}

trap cleanup SIGINT

# Start lazy-pages
sudo criu lazy-pages --images-dir "$dump_dir" --page-server --address "$src_address" --port "$port" &
lazy_page_pid=$!
echo "Lazy-pages launched"
sleep 1

# Restore the process
echo "Restoring..."
sudo criu restore -D "$dump_dir" --shell-job --lazy-pages

cleanup
