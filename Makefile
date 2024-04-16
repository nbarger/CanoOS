BUILDDIR=build
SRCDIR=src
OBJDIR=build/obj
ARCHDIR=src/arch/i686

# for GCC build
GCCNAME=gcc-13.2.0
GCCURL=https://ftp.gnu.org/gnu/gcc/$(GCCNAME)/$(GCCNAME).tar.gz
GCCDIR=$(BUILDDIR)/$(GCCNAME)
MAKE_FLAGS=-j$(shell nproc)

# for kernel build
CC=$(BUILDDIR)/$(GCCNAME)-build/gcc/gcc
CFLAGS=-O2 -g -ffreestanding -Wall -Wextra
ASM=nasm
LIBS=-nostdlib -lk -lgcc

SRC=\
    $(SRCDIR)/kernel/kernel.c\

OBJ=\
    $(OBJDIR)/kernel/kernel.o\

OUT=$(BUILDDIR)/kernel/canoos.kernel

canoos-all: build-kernel

build-kernel: $(OUT)

$(OUT): $(OBJ) $(ARCHDIR)/linker.ld
	mkdir -p $(BUILDDIR)/kernel-build $(OBJ) $(LIBS)
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS)

$(OBJ): $(SRC)
	mkdir -p $(BUILDDIR)/kernel-build/obj


build-gcc: setup-gcc

setup-gcc: $(GCCDIR)
	# building gcc (FIXME: gpg signature is not being verified)
	mkdir -p $(GCCDIR)-build
	cd $(GCCDIR)-build && ../$(GCCNAME)/configure --target=i686-elf --disable-nls --enable-languages=c,c++ --without-headers
	make -C $(GCCDIR)-build all-gcc $(MAKE_FLAGS)

$(GCCDIR):
	mkdir -p $(BUILDDIR)
	# downloading gcc
	curl -o $(GCCDIR).tar.gz $(GCCURL)
	tar -xf $(GCCDIR).tar.gz -C $(BUILDDIR)

destroy:
	rm -rf $(BUILDDIR)

.PHONY: canoos-all build-gcc setup-gcc destroy
