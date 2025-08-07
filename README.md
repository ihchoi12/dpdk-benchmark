# dpdk-benchmark

### Install required packages
$ sudo apt update
$ sudo apt install meson ninja-build
$ sudo apt install -y build-essential meson ninja-build libnuma-dev python3-pyelftools pkg-config


### Download codebase
$ wget https://fast.dpdk.org/rel/dpdk-23.11.tar.xz
$ tar -xvf dpdk-23.11.tar.xz
$ cd dpdk-23.11


### Create build dir
$ meson setup build -Dexamples= -Ddrivers=net/mlx5
$ cd build
$ ninja





### l3fwd with 8 cores
$ sudo ./build/examples/dpdk-l3fwd -l 0-7 -n 4 -a 0000:31:00.1 -- -p 0x1 --config="(0,0,0),(0,1,1),(0,2,2),(0,3,3),(0,4,4),(0,5,5),(0,6,6),(0,7,7)" --eth-dest=0,08:c0:eb:b6:cd:5d