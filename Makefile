TOOLS_DIR=${PWD}/tools

### HELP ###

help:
	@echo "-------------------------------------------------------------------------"
	@echo "This repository contains a very simple building environment for Zephyr OS"
	@echo "-------------------------------------------------------------------------"
	@echo "You can use the following rules:"
	@echo "    make/init - To prepare the environment"

init:
	make toolchain/init
	make zephyr/init
	make xc3sprog/init

ctags:
	ctags -R litex \
		third_party/migen \
		third_party/litex-boards \
		third_party/litevideo \
		third_party/litesata \
		third_party/litesdcard \
		third_party/litejesd204b \
		third_party/liteeth \
		third_party/liteiclink \
		third_party/litedram \
        third_party/zephyr

### RISCV TOOLCHAIN ###

TOOLCHAIN_DIR=${TOOLS_DIR}/toolchain
RISCV_TOOLCHAIN_DIR=${TOOLCHAIN_DIR}/riscv-gnu-toolchain
TOOLCHAIN_BUILD_DIR=${TOOLCHAIN_DIR}/build

toolchain/init:
	make toolchain/prerequisites
	make toolchain/build
	make toolchain/direnv

toolchain/prerequisites:
	sudo apt install -y autoconf automake autotools-dev curl libmpc-dev \
                     libmpfr-dev libgmp-dev gawk build-essential bison flex \
                     texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

toolchain/build:
	mkdir -p ${TOOLCHAIN_DIR}; mkdir -p ${TOOLCHAIN_BUILD_DIR}
	cd ${TOOLCHAIN_DIR}; git clone --recursive https://github.com/riscv/riscv-gnu-toolchain ${RISCV_TOOLCHAIN_DIR}
	cd ${RISCV_TOOLCHAIN_DIR}; ./configure --prefix=${TOOLCHAIN_BUILD_DIR}/riscv
	cd ${RISCV_TOOLCHAIN_DIR}; make -j8

toolchain/direnv:
	echo "PATH_add ${TOOLCHAIN_BUILD_DIR}/riscv/bin" >> .envrc.local
	direnv allow .

.PHONY: toolchain/init toolchain/prerequisites toolchain/build toolchain/direnv

### GIT ###

git/update:
	git submodule sync
	git submodule update --init --remote
	git submodule foreach 'git submodule update --init --recursive'

.PHONY: git/update

### ZEPHYR ###

ZEPHYR_DIR=${TOOLS_DIR}/zephyr
ZEPHYR_SDK_DIR=${ZEPHYR_DIR}/sdk

ZEPHYR_SDK_URL=https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.11.2/zephyr-sdk-0.11.2-setup.run
ZEPHYR_SDK_FILE_NAME=zephyr-sdk.run
ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_DIR}

zephyr/init:
	make zephyr/prerequisites
	make zephyr/sdk
	make zephyr/direnv

zephyr/prerequisites:
	sudo apt install --no-install-recommends -y git cmake ninja-build gperf \
                     ccache dfu-util device-tree-compiler wget \
                     python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
                     make gcc gcc-multilib
	wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
	sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
	sudo apt update
#    sudo apt --reinstall install cmake
	pip3 install west
	pip3 install -r third_party/zephyr/scripts/requirements.txt

zephyr/sdk:
	rm -rf ${ZEPHYR_DIR}
	mkdir -p ${ZEPHYR_SDK_DIR}
	cd ${ZEPHYR_DIR}; wget ${ZEPHYR_SDK_URL} -O ${ZEPHYR_SDK_FILE_NAME}
	cd ${ZEPHYR_DIR}; chmod +x ${ZEPHYR_SDK_FILE_NAME}
	cd ${ZEPHYR_DIR}; echo n | ./${ZEPHYR_SDK_FILE_NAME} -- -d ${ZEPHYR_SDK_DIR}

zephyr/direnv:
	echo "export ZEPHYR_TOOLCHAIN_VARIANT=${ZEPHYR_TOOLCHAIN_VARIANT}" >> .envrc.local
	echo "export ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR}" >> .envrc.local
	direnv allow .

.PHONY: zephyr/init zephyr/prerequisites zephyr/sdk zephyr/direnv

### XC3SPROG ###

XC3SPROG_DIR=${TOOLS_DIR}/xc3sprog
XC3SPROG_BUILD_DIR=${XC3SPROG_DIR}/build
LIBFTD2XX_DIR=${TOOLS_DIR}/libftd2xx

xc3sprog/init:
	make xc3sprog/prerequisites
	make xc3sprog/build
	make xc3sprog/direnv

xc3sprog/prerequisites:
	sudo apt install -y libusb-dev libftdi-dev cmake
	mkdir -p ${LIBFTD2XX_DIR}
	cd ${LIBFTD2XX_DIR}; wget https://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx-i386-1.4.8.gz
	cd ${LIBFTD2XX_DIR}; tar -xzf libftd2xx-i386-1.4.8.gz
	cd ${LIBFTD2XX_DIR}; cd release/build && \
        sudo cp libftd2xx.* /usr/local/lib && \
        sudo chmod 0755 /usr/local/lib/libftd2xx.so.1.4.8 && \
        sudo ln -sf /usr/local/lib/libftd2xx.so.1.4.8 /usr/local/lib/libftd2xx.so

xc3sprog/build:
	mkdir -p ${XC3SPROG_DIR}
	cd ${XC3SPROG_DIR}; git clone --recursive https://github.com/rw1nkler/xc3sprog .
	mkdir -p ${XC3SPROG_BUILD_DIR};
	cd ${XC3SPROG_BUILD_DIR}; cmake ..
	cd ${XC3SPROG_BUILD_DIR}; make

xc3sprog/direnv:
	echo "PATH_add ${XC3SPROG_BUILD_DIR}" >> .envrc.local
	direnv allow .
