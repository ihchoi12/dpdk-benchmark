# dpdk-benchmark

### Install required packages
$ sudo apt update
$ sudo apt install meson ninja-build
$ sudo apt install liblua5.3-dev libpcap-dev liblua5.3-dev
$ sudo apt install -y build-essential meson ninja-build libnuma-dev python3-pyelftools pkg-config


### Download l3fwd codebase
$ wget https://fast.dpdk.org/rel/dpdk-23.11.tar.xz
$ tar -xvf dpdk-23.11.tar.xz
$ cd dpdk-23.11


### Build dir
$ meson setup build -Dexamples=l3fwd -Ddrivers=net/mlx5
$ cd build
$ ninja


### Download Pktgen-DPDK codebase
$ git clone https://github.com/pktgen/Pktgen-DPDK.git
$ cd Pktgen-DPDK
$ git checkout pktgen-23.10.2
$ export RTE_SDK=/local/inho/dpdktest/dpdk-23.11
$ export RTE_TARGET=build
Pktgen-DPDK/app/meson.build: "deps += [dependency('numa', required: true)]" ==> "deps += [dependency('numa', required: false)]"
$ meson setup build
$ ninja -C build

### Re-build Pktgen-DPDK
Pktgen-DPDK$ ninja -C build

### Re-build l3fwd
dpdk-23.11$ ninja -C build examples/dpdk-l3fwd


### Pktgen-DPDK with 4 cores
Pktgen-DPDK$ sudo ./build/app/pktgen -l 0-4 -n 4 --allow=0000:31:00.1 -- -P -m "[1-2:3-4].0" -f scripts/test.lua

### l3fwd with 8 cores
dpdk-23.11$ sudo ./build/examples/dpdk-l3fwd -l 0-7 -n 4 -a 0000:31:00.1 -- -p 0x1 --config="(0,0,0),(0,1,1),(0,2,2),(0,3,3),(0,4,4),(0,5,5),(0,6,6),(0,7,7)" --eth-dest=0,08:c0:eb:b6:cd:5d