
> **NOTE**
> 
> The qjls project is still an experiment.


## Overview

This repository contains [QuickJS](https://bellard.org/quickjs/), selected QuickJS modules and the associated makefiles.
The targeted operating systems are Linux and Windows. The targeted architectures are x86, x86-64 and ARM.


## How to setup?

This repository mainly contains submodule and so needs to be initialized before it can be used

```bash
git submodule update --init --recursive
```

## How to build?

Prerequisites

You need make and gcc tools

Build core modules
```bash
make
```

Configure then make all modules
```bash
make configure
make all
```

Create a distribution folder containing the binaries
```bash
make dist
```

Clean the build files
```bash
make clean-all
```

### How to build on Linux?

Prerequisites

Install gtk-webkit2

```bash
sudo apt-get install libgtk-3-dev libwebkit2gtk-4.0-dev
```

### How to build on Windows (MinGW)?
<!--- Tested on Windows 10 with msys packages available in March 2019 -->
Prerequisites

Install [msys2](https://www.msys2.org/)

Install make and mingw gcc
```bash
pacman -S make mingw-w64-x86_64-gcc
```

Set mingw64 and msys in the beginning of your path using:
```
SET PATH=...\msys64\mingw64\bin;...\msys64\usr\bin;%PATH%
```
