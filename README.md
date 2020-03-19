![Build Status](http://83.238.210.90:8080/buildStatus/icon?job=litex-zephyr-build)

# Getting Started

## Prerequisites

This repository requires `direnv` program. You can install it using:
```
sudo apt install direnv
```

Then you should add appropriate hook to your shell init-file, i.e., for bash
you should add these lines to your `~/.bashrc`:

```
eval "$(direnv hook bash)"
```

Direnv is used to manage virtual environment and setting some system environment variables automatically.

If you want to see the virtual environment in your prompt, read the
[Python chapter](https://github.com/direnv/direnv/wiki/Python) in direnv Wiki.

## Basic Usage

This repository ensures that you are using only local litex and migen repositories.
It also creates a python virtual environment with all required packages.
This virtual environment resides in the `.direnv/` directory in this repository
and is automatically set when you enter this repository.

The working flow with this repository is almost identical to using
the LiteX and Zephyr in the standard way. The only difference is that
the `zephyr-env.sh` file is sourced automatically within this directory.

### Cloning repository

```
git clone --recursive https://github.com/rw1nkler/litex-zephyr-build
```

### Preparing repository

```
make init
```

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
````
