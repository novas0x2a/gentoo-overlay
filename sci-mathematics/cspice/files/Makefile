CC=gcc
prefix=/usr
CFLAGS=-O2
LDFLAGS=-Wl,-export-dynamic -Wl,-no-undefined -Wl,-as-needed

all: cspice csupport

cspice:
	cd src/$@ && \
	for i in *.c; do \
		libtool --mode=compile --tag=CC ${CC} ${CFLAGS} -c $$i; \
	done
	libtool --mode=link --tag=CC ${CC} ${LDFLAGS} -o lib$@.la src/$@/*.lo -rpath ${DESTDIR}${prefix}/lib -lm

csupport:
	cd src/$@ && \
	for i in *.c; do \
		libtool --mode=compile --tag=CC ${CC} ${CFLAGS} -c $$i; \
	done
	libtool --mode=link --tag=CC ${CC} ${LDFLAGS} -o lib$@.la src/$@/*.lo -rpath ${DESTDIR}${prefix}/lib libcspice.la -lm

install:
	install -m 755 -d ${DESTDIR}${prefix}/include/cspice
	install -m 644 -t ${DESTDIR}${prefix}/include/cspice include/*
	libtool --mode=install install -D -c -s libcspice.la   ${DESTDIR}${prefix}/lib/libcspice.la
	libtool --mode=install install -D -c -s libcsupport.la ${DESTDIR}${prefix}/lib/libcsupport.la

clean:
	libtool --mode=clean rm -f libcspice.la libcsupport.la src/cspice/*.lo src/csupport/*.lo

.SUFFIXES:
.PHONY: cspice csupport install
