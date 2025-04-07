#!/bin/bash
# FIXME: Change it to the CRIU location
DAPPER_PATH=./
criu=$DAPPER_PATH/criu-4.0/criu/criu

if [ ! -f "$criu" ]
then
    echo "Cannot find criu! Please set the DAPPER_PATH correctly!"
    exit 1
fi

if [ $# != 1 ]; then
    echo "Use ./restore.sh <dir>"
    exit 1
fi

sudo $criu restore -vv -o restore.log -j -D $1
