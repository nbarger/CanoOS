#!/bin/sh

BUILDDIR="build/tools"
GCCNAME="gcc-11.2.0"
GCCURL="https://ftp.gnu.org/gnu/gcc/$GCCNAME/$GCCNAME.tar.gz"
GCCDIR="$BUILDDIR/$GCCNAME"

BINUTILSNAME="binutils-2.42"
BINUTILSURL="https://ftp.gnu.org/gnu/binutils/$BINUTILSNAME.tar.gz"
BINUTILSDIR="$BUILDDIR/$BINUTILSNAME"

function download_build() {
    set -xe
    
    mkdir -p $BUILDDIR
    
    # downloading binutils
    curl -o $BINUTILSDIR.tar.gz $BINUTILSURL
    tar -xf $BINUTILSDIR.tar.gz -C $BUILDDIR

    # building binutils (FIXME: gpg signature is not being verified)
    mkdir -p $BINUTILSDIR-build
    cd $BINUTILSDIR-build
    ../$BINUTILSNAME/configure --target=i686-elf --prefix="$(pwd)" --with-sysroot --disable-nls --disable-werror
    make
    make install

    cd ../../../

    # Adding binutils to the path for current shell session
    export PATH="$(pwd)/$BINUTILSDIR-build/bin:$PATH"

    # downloading gcc
    curl -o $GCCDIR.tar.gz $GCCURL
    tar -xf $GCCDIR.tar.gz -C $BUILDDIR

    # building gcc (FIXME: gpg signature is not being verified)
    mkdir -p $GCCDIR-build
    cd $GCCDIR-build
    ../$GCCNAME/configure --target=i686-elf --prefix="$(pwd)" --disable-nls --enable-languages=c,c++ --without-headers --disable-multilib --disable-build-format-warnings
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc

    cd ../../../

    # Adding gcc to the path for current shell session
    export PATH="$(pwd)/$GCCDIR-build/bin:$PATH"
}

while getopts 'ihp' opt; do
    case "$opt" in
        i) 
          download_build
          ;;
        p)
          echo "export PATH=$(pwd)/$BINUTILSDIR-build/bin:$(pwd)/$GCCDIR-build/bin:$PATH" >> ~/.bashrc
          ;;
        h|?)
          echo "Usage: $(basename $0) [-i] [-h] [-p]"
          exit 1
          ;;
    esac
done
shift "$(($OPTIND -1))"
