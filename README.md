# dpdk-benchmark

### Install required packages and setup machine
$ sudo apt update
$ sudo apt install meson ninja-build
$ sudo apt install liblua5.3-dev libpcap-dev liblua5.3-dev
$ sudo apt install -y build-essential meson ninja-build libnuma-dev python3-pyelftools pkg-config
$ sudo ./setup_machines


### Download dpdk-23.11 codebase
$ wget https://fast.dpdk.org/rel/dpdk-23.11.tar.xz
$ tar -xvf dpdk-23.11.tar.xz
$ cd dpdk-23.11
$ meson setup build -Dprefix=$HOME/dpdk-23.11-install
$ ninja -C build
$ ninja -C build install   # or: meson install -C build

# Set env var to use dpdk-23.11
export PKG_CONFIG_PATH=$HOME/dpdk-23.11-install/lib/x86_64-linux-gnu/pkgconfig:$HOME/dpdk-23.11-install/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$HOME/dpdk-23.11-install/lib/x86_64-linux-gnu:$HOME/dpdk-23.11-install/lib:$LD_LIBRARY_PATH

# to run DPDK application with sudo
$ echo "$HOME/dpdk-23.11-install/lib/x86_64-linux-gnu" | sudo tee /etc/ld.so.conf.d/dpdk.conf
$ echo "$HOME/dpdk-23.11-install/lib" sudo tee -a /etc/ld.so.conf.d/dpdk.conf
$ sudo ldconfig

# version check ->  should print 23.11.* 
pkg-config --modversion libdpdk


### Build dir
$ meson setup build -Dexamples=l3fwd -Ddrivers=net/mlx5
$ cd build
$ ninja


### Download Pktgen-DPDK codebase
$ git clone https://github.com/pktgen/Pktgen-DPDK.git
$ cd Pktgen-DPDK
$ git checkout pktgen-23.10.2
$ export RTE_SDK=$HOME/Autokernel/dpdk-benchmark/dpdk-23.11
$ export RTE_TARGET=build
[edit a line]
Pktgen-DPDK/app/meson.build: 
- "deps += [dependency('numa', required: true)]" 
+ "deps += [dependency('numa', required: false)]"
$ meson setup build
$ meson configure build -Denable_lua=true
$ ninja -C build

### Re-build Pktgen-DPDK
Pktgen-DPDK$ ninja -C build

### Re-build l3fwd
dpdk-23.11$ ninja -C build examples/dpdk-l3fwd


### Pktgen-DPDK with 14 cores
Pktgen-DPDK$ sudo ./build/app/pktgen -l 0-14 -n 4 --proc-type auto --socket-mem=1024 --file-prefix pktgen1 --allow=0000:31:00.1 -- -P -T -m "[1-7:8-14].0"

### l3fwd with 
[1 core] dpdk-23.11$ sudo ./build/examples/dpdk-l3fwd -l 0 -n 4 -a 0000:31:00.1 -- -p 0x1 --config="(0,0,0)" --eth-dest=0,08:c0:eb:b6:cd:5d
[8 core] dpdk-23.11$ sudo ./build/examples/dpdk-l3fwd -l 0-7 -n 4 -a 0000:31:00.1 -- -p 0x1 --config="(0,0,0),(0,1,1),(0,2,2),(0,3,3),(0,4,4),(0,5,5),(0,6,6),(0,7,7)" --eth-dest=0,08:c0:eb:b6:cd:5d



### Useful postings
Pktgen-DPDK configuration: https://edc.intel.com/content/www/us/en/design/products/ethernet/appnote-e810-adq-config-guide/example-running-dpdk-pktgen-traffic/


