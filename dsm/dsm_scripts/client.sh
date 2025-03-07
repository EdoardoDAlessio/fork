
#!/bin/bash

# Configurable variables
src_address="10.128.0.8"
port=1234
dump_dir="$(pwd)/dump"

# Ensure dump directory exists
mkdir -p "$dump_dir"



cleanup() {
    echo "Cleaning up..."
    sudo kill -9 "$lazy_page_pid" 2>/dev/null
    #sudo kill -9 $(pidof criu) 2>/dev/null
    sudo rm -r dump
    exit 1
}

trap cleanup SIGINT

sudo criu lazy-pages --images-dir "$dump_dir" --page-server --address "$src_address" --port "$port" &
lazy_page_pid=$!
echo "Lazy-pages lauched"
sleep 1
echo "Restoring"
sudo criu restore -D "$dump_dir" --shell-job --lazy-pages


cleanup
