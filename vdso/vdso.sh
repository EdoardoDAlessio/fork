#!/bin/bash
#pushd ..
./vdso/vdso-test.sh > /dev/null &
mkdir -p ./vdso/dump-dir
#sleep 1
sudo ./criu-4.0/criu/criu dump -t $(pgrep vdso-test.sh) -D ./vdso/dump-dir -j
sudo chown $(id -un):$(id -gn) ./vdso/dump-dir -R
python3 ./criu-4.0/crit/crit vdso_init ./vdso/dump-dir
rm -rf ./vdso/dump-dir
#killall test.sh
#popd
