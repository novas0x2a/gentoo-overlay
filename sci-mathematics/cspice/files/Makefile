CC=gcc
prefix=/usr
CFLAGS=-O2
LDFLAGS=-Wl,-export-dynamic -Wl,-no-undefined -Wl,-as-needed


LIBTOOL ?= libtool

all: libcsupport.la

CSPICE_OBJ=$(patsubst %.c,%.lo,$(wildcard src/cspice/*.c))
CSUPPORT_OBJ=$(patsubst %.c,%.lo,$(wildcard src/csupport/*.c))

%.lo : %.c
	$(LIBTOOL) --mode=compile --tag=CC ${CC} ${CFLAGS} -c $^ -o $@

libcspice.la: $(CSPICE_OBJ)
	$(LIBTOOL) --mode=link --tag=CC ${CC} ${LDFLAGS} -o $@ $^ -rpath ${DESTDIR}${prefix}/lib -lm

libcsupport.la: $(CSUPPORT_OBJ) libcspice.la
	$(LIBTOOL) --mode=link --tag=CC ${CC} ${LDFLAGS} -o $@ $^ -rpath ${DESTDIR}${prefix}/lib -lm

install:
	install -m 755 -d ${DESTDIR}${prefix}/include/cspice
	install -m 644 include/* ${DESTDIR}${prefix}/include/cspice
	install -m 755 -d ${DESTDIR}${prefix}/lib
	$(LIBTOOL) --mode=install install -c -s libcspice.la libcsupport.la ${DESTDIR}${prefix}/lib

clean:
	$(LIBTOOL) --mode=clean rm -f libcspice.la libcsupport.la *.lo

.SUFFIXES:
.PHONY: all install clean
