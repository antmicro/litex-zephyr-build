![Build Status](http://83.238.210.90:8080/buildStatus/icon?job=litex-zephyr-build)

# Getting Started

## Clone repository
```
git clone --recursive https://github.com/rw1nkler/litex-zephyr-build
```

## Install Prerequisites

This repository requires `direnv` program. It is used to manage the environment
variables and the python virtual environment within this repository.
You can install and configure `direnv` using  `prerequisites.sh` script:

```
./prerequisites.sh
```

The script will install direnv and add a special hook to the end
of your `~/.bashrc`. This is *standard* setup for this program.

If you want to see the virtual environment in your prompt,
which is *highly recommended*, read the
[Python chapter](https://github.com/direnv/direnv/wiki/Python) in `direnv` Wiki.
This will allow you to see that the `direnv` sets the proper virtual environment
for this directory.

## Basic Usage

This repository ensures that you are using only local litex and migen repositories.
It also creates a python virtual environment with all the required packages.
This virtual environment resides in the `.direnv/` directory in this repository
and is automatically set when you enter this directory.

The working flow with this repository is almost identical to using
the LiteX and Zephyr in the standard way. The only difference is that
the `zephyr-env.sh` file is sourced automatically within this directory.

### Preparing tools

To prepare the needed tools, use:
```
make init
```

The command will install the following tools to the `tools/` directory:
- riscv toolchain
- zephyr SDK
- xc3sprog

For selective installation, see the `Makefile`.

### Compiling LiteX (for Arty Board)

```
cd third_party/litex/litex/boards/targets
./arty.py --with-ethernet
```

Output files will be placed in the standard `soc_ethernetsoc_arty` directory.

### Compiling Zephyr

```
cd third_party/zephyr/samples/hello_world
mkdir build
cd build
cmake -DBOARD=litex_vexriscv ..
make -j$(nproc)
```
