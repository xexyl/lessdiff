CP= cp
INSTALL= install

SH_FILE= lessdiff

DESTDIR= /usr/local/bin
DEST_MANDIR= /usr/local/share/man/man1

all:
	@echo nothing to do for $@


install:
	${INSTALL} -d -m 0755 ${DESTDIR}
	${INSTALL} -m 0555 ${SH_FILE} ${DESTDIR}
