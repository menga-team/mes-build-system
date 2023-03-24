# MES-Template
A "clone and go" MES project template.

## Installation

After cloning the repository, initialize the needed git submodules.
```shell
git submodule update --init
```

## Usage

### Simulate
To simulate your game using Virtual-MES, build the executable using make, then simply run it.
Remember to install the SDL2 library, which is needed by V-MES, first.
```shell
make simulate
./game
```

### Upload
To test your game on real hardware you can use the `flash` target.

In order to flash your game you first need to enter:

```shell
make flash-setup
```

This will prepare everything for using `make flash`, if you update the
MES submodule you might need to do it again.

```shell
make flash
```

After that you can just use `make flash` and upload your game to the
CPU.
