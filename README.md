# CanoOS

CanoOS is a Unix-inspired operating system that makes use of the set of software created by @CobbCoding1. The OS intends to be packaged with TIM as a environment for running programs, CanoScript for writing programs, and Cano as the text editor. The shell interface will be called Canosh, and will be written in CanoScript.

As you can see, this is an attempt to create an entire domination over the software industry using the label "Cano."

## Build

You can build CanoOS using Make.
The Makefile depends on the following tools:
- nasm
- i686-elf-gcc
- i686-elf-binutils
- qemu for i386

You can either install the i686-elf versions of gcc and binutils using your favourite package manager or build them from source using the [setup.sh](https://github.com/Garihosu/CanoOS/blob/main/setup.sh) script.

The setup script will download and build both gcc and binutils using this command:
```sh
./setup.sh -i
```

The following command will tell the setup script to add i686-gcc and i686-binutils to your PATH by making a new entry in your `~/.bashrc` file:
```sh
./setup.sh -p
```

Building CanoOS:
```sh
make
```

## Contributing

For contributing, read [CONTRIBUTING.md](https://github.com/Garihosu/CanoOS/blob/main/CONTRIBUTING.md) (as you probably know already).

You can find a list of to-dos at [TODO.md](https://github.com/Garihosu/CanoOS/blob/main/TODO.md).
