BUILDDIR := build
SRCDIR := src
OBJDIR := $(BUILDDIR)/obj
ARCHDIR := $(SRCDIR)/arch/i686

CC := i686-elf-gcc
CFLAGS := -O2 -g -ffreestanding -Wall -Wextra -m32
LDFLAGS := -T $(ARCHDIR)/linker.ld
AS := nasm
LIBS := -nostdlib -lgcc
BINARY := $(BUILDDIR)/canoos.kernel

KERNEL_SRC := $(wildcard $(SRCDIR)/kernel/*.c)
KERNEL_OBJ := $(patsubst $(SRCDIR)/kernel/%.c,$(OBJDIR)/%.o,$(KERNEL_SRC))

ARCH_SRC := $(wildcard $(ARCHDIR)/*.asm)
ARCH_OBJ := $(patsubst $(ARCHDIR)/%.asm,$(OBJDIR)/%.o,$(ARCH_SRC))

canoos-all: build

build: $(ARCH_OBJ) $(KERNEL_OBJ) link

$(ARCH_OBJ): $(OBJDIR)/%.o : $(ARCHDIR)/%.asm
	mkdir -p $(dir $@)
	$(AS) -felf32 $(patsubst $(OBJDIR)/%.o,$(ARCHDIR)/%.asm,$@) -o $@

$(KERNEL_OBJ): $(OBJDIR)/%.o : $(SRCDIR)/kernel/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $(patsubst $(OBJDIR)/%.o,$(SRCDIR)/kernel/%.c,$@) -o $@

link:
	$(CC) $(LDFLAGS) $(ARCH_OBJ) $(KERNEL_OBJ) -o $(BINARY) $(LIBS)

destroy:
	rm -rf $(BUILDDIR)

clean:
	rm -rf $(OBJDIR)

.PHONY: canoos-all build destroy clean
