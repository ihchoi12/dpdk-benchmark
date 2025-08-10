# DPDK Benchmark

High-performance packet I/O experiments using **DPDK 23.11**, **Pktgen-DPDK 23.10.2**, and **l3fwd**.

## Install Required Packages & Setup Machine
```bash
sudo apt update
sudo apt install -y meson ninja-build liblua5.3-dev libpcap-dev \
    build-essential libnuma-dev python3-pyelftools pkg-config
sudo ./setup_machines
```

## Download & Install DPDK 23.11
```bash
wget https://fast.dpdk.org/rel/dpdk-23.11.tar.xz
tar -xvf dpdk-23.11.tar.xz
cd dpdk-23.11

# Install under $HOME/dpdk-23.11-install
meson setup build -Dprefix=$HOME/dpdk-23.11-install
ninja -C build
ninja -C build install   # or: meson install -C build
```

## Environment Setup
```bash
# Use DPDK 23.11 for builds
export PKG_CONFIG_PATH=$HOME/dpdk-23.11-install/lib/x86_64-linux-gnu/pkgconfig:$HOME/dpdk-23.11-install/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$HOME/dpdk-23.11-install/lib/x86_64-linux-gnu:$HOME/dpdk-23.11-install/lib:$LD_LIBRARY_PATH
```

To run DPDK apps with `sudo`:
```bash
echo "$HOME/dpdk-23.11-install/lib/x86_64-linux-gnu" | sudo tee /etc/ld.so.conf.d/dpdk.conf
echo "$HOME/dpdk-23.11-install/lib" | sudo tee -a /etc/ld.so.conf.d/dpdk.conf
sudo ldconfig
```

## Version Check
```bash
pkg-config --modversion libdpdk
# Should print: 23.11.*
```

## Build DPDK Example (l3fwd)
```bash
cd dpdk-23.11
meson setup build -Dexamples=l3fwd -Ddrivers=net/mlx5
cd build
ninja
```

## Download & Build Pktgen-DPDK 23.10.2
```bash
git clone https://github.com/pktgen/Pktgen-DPDK.git
cd Pktgen-DPDK
git checkout pktgen-23.10.2
```

If `libnuma-dev` is missing, make NUMA optional:
```diff
# File: Pktgen-DPDK/app/meson.build
- deps += [dependency('numa', required: true)]
+ deps += [dependency('numa', required: false)]
```

Build:
```bash
export RTE_SDK=$HOME/Autokernel/dpdk-benchmark/dpdk-23.11
export RTE_TARGET=build

meson setup build
meson configure build -Denable_lua=true
ninja -C build
```

Re-build (if needed):
```bash
ninja -C build
```

## Re-build l3fwd
```bash
cd dpdk-23.11
ninja -C build examples/dpdk-l3fwd
```

## Run Examples

### Pktgen-DPDK (14 cores, single port)
```bash
sudo ./build/app/pktgen \
  -l 0-14 -n 4 --proc-type auto --socket-mem=1024 \
  --file-prefix pktgen1 --allow=0000:31:00.1 \
  -- -P -T -m "[1-7:8-14].0"
```

### l3fwd (1 core)
```bash
sudo ./build/examples/dpdk-l3fwd \
  -l 0 -n 4 -a 0000:31:00.1 -- \
  -p 0x1 --config="(0,0,0)" \
  --eth-dest=0,08:c0:eb:b6:cd:5d
```

### l3fwd (8 cores)
```bash
sudo ./build/examples/dpdk-l3fwd \
  -l 0-7 -n 4 -a 0000:31:00.1 -- \
  -p 0x1 \
  --config="(0,0,0),(0,1,1),(0,2,2),(0,3,3),(0,4,4),(0,5,5),(0,6,6),(0,7,7)" \
  --eth-dest=0,08:c0:eb:b6:cd:5d
```

## References
- [Intel E810 ADQ Config Guide - Example Running DPDK Pktgen Traffic](https://edc.intel.com/content/www/us/en/design/products/ethernet/appnote-e810-adq-config-guide/example-running-dpdk-pktgen-traffic/)
