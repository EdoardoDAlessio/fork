.PHONY: all vdso clean

all:
	make -C criu-4.0 -j$(shell nproc)
	make -C criu-4.0/dsm_client
	make -C tools

vdso:
	$(shell ./vdso/vdso.sh)

clean:
	make -C criu-4.0 clean
	make -C tools clean
