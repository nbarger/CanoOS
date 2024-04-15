BUILDDIR=build
SRCDIR=src
GCCNAME=gcc-13.2.0
GCCURL=https://ftp.gnu.org/gnu/gcc/$(GCCNAME)/$(GCCNAME).tar.gz
GCCDIR=$(BUILDDIR)/$(GCCNAME)
MAKE_FLAGS=-j$(shell nproc)
CC=$(BUILDDIR)/$(GCCNAME)-build/gcc/xgcc

setup: $(GCCDIR)
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

.PHONY: setup destroy
