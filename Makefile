
CC := gcc @ccflags
CC_RELEASE := gcc @ccflags_release

LIBRARIES := # lib/liba.so lib/libb.a -lm -lncurses
GLOBALS := ccflags ccflags_release Makefile $(LIBRARIES)

NAME := bin
VERSION := 1.0.0-wipdev

DETECT_GHOST_FILES := $(shell if [ -d out/ghost/ ]; then find out/ghost -type f| sed -e "s:^out/ghost:src:g"; fi)
SOURCE_FILES := $(shell find src -name "*.c")
SRC_OBJFILES := $(patsubst src/%.c,out/objsrc/%.o,$(SOURCE_FILES))
REL_OBJFILES := $(patsubst src/%.c,out/objrel/%.o,$(SOURCE_FILES))
SLL_OBJFILES := $(patsubst src/%.c,out/objsll/%.o,$(SOURCE_FILES))
DLL_OBJFILES := $(patsubst src/%.c,out/objdll/%.o,$(SOURCE_FILES))

HEADERS := $(shell find src -name "*.h")

INCLDEPS := # $(LIBRARIES) if you want to

INSTALLTO ?= /usr/local/bin

dflt: devbuild test
#dflt: release
#dflt: staticlib test
#dflt: sharedlib test

-include $(out/objsrc/*.d)
-include $(out/objrel/*.d)
-include $(out/objsll/*.d)
-include $(out/objdll/*.d)

### DEBUG BUILD

$(NAME): $(SRC_OBJFILES) $(GLOBALS) $(DETECT_GHOST_FILES)
	$(CC) -o $@ out/objsrc/*.o $(LIBRARIES)

out/objsrc/:
	mkdir -p $@

out/objsrc/%.o: src/%.c $(GLOBALS) | out/objsrc/ out/ghost/
	@touch out/ghost/$*.c
	$(CC) -MMD -MP -c $< -o $@

### FULL BUILD

$(NAME)_release: clean $(REL_OBJFILES) $(GLOBALS) $(DETECT_GHOST_FILES)
	$(CC) -o $@ out/objrel/*.o $(LIBRARIES)

out/objrel/:
	mkdir -p $@

out/objrel/%.o: src/%.c $(GLOBALS) | out/objrel/ out/ghost/
	@touch out/ghost/$*.c
	$(CC_RELEASE) -MMD -MP -c $< -o $@

### STATIC LIB BUILD

lib$(NAME).a: $(SLL_OBJFILES) $(GLOBALS) $(DETECT_GHOST_FILES)
	ar rcs $@ out/objsll/*.o $(INCLDEPS)

out/objsll/:
	mkdir -p $@

out/objsll/%.o: src/%.c $(GLOBALS) | out/objsll/ out/ghost/
	@touch out/ghost/$*.c
	$(CC) -MMD -MP -c $< -o $@

### SHARED LIB BUILD

lib$(NAME).so: $(DLL_OBJFILES) $(GLOBALS) $(DETECT_GHOST_FILES)
	$(CC) -o $@ -shared out/objdll/*.o $(INCLDEPS)

out/objdll/:
	mkdir -p $@

out/objdll/%.o: src/%.c $(GLOBALS) | out/objdll/ out/ghost/
	@touch out/ghost/$*.c
	$(CC) -MMD -MP -fPIC -c $< -o $@

### TARBALL

lib$(NAME)-$(VERSION).tar.gz: sharedlib staticlib src/lib$(NAME).h
	mkdir -p out/tar/
	cp lib$(NAME).a     out/tar/
	cp lib$(NAME).so    out/tar/
	cp src/lib$(NAME).h out/tar/
	mv out/tar/ out/$(NAME)-$(VERSION)/
	@echo
	tar cvzCf out $@ $(NAME)-$(VERSION)/
	@echo
	rm -rf out/$(NAME)-$(VERSION)/

### PHONY

.PHONY: clean all devbuild release staticlib sharedlib tarball dflt test install_so install_a uninstall

clean:
	rm -f ./$(NAME)
	rm -f ./$(NAME)_release
	rm -f ./lib$(NAME).a
	rm -f ./lib$(NAME).so
	rm -f ./lib$(NAME)-*.tar.gz
	rm -rf out

devbuild: $(NAME)
release: $(NAME)_release
staticlib: lib$(NAME).a
sharedlib: lib$(NAME).so
tarball: lib$(NAME)-$(VERSION).tar.gz

all: clean release devbuild tarball staticlib sharedlib test

test: SHELL:=/bin/bash
test:
	@mkdir -p out/log/
	@set -o pipefail; \
	(cd test && $(MAKE) NAME=$(NAME) 2>&1) | tee out/log/test.log

install_so: lib$(NAME).so
	@if [ $$(id -u) -ne 0 ] && [ $(INSTALLTO) = /usr/local/bin ]; then echo --- YOU MAY WISH TO INSTALL AS ROOT; fi
	install -Dm755 $< $(INSTALLTO)/$<

install_a: lib$(NAME).a
	@if [ $$(id -u) -ne 0 ] && [ $(INSTALLTO) = /usr/local/bin ]; then echo --- YOU MAY WISH TO INSTALL AS ROOT; fi
	install -Dm755 $< $(INSTALLTO)/$<

uninstall:
	rm -f $(INSTALLTO)/lib$(NAME).so
	rm -f $(INSTALLTO)/lib$(NAME).a

### GHOST CHECKING

src/%.c:
#	if [ exists($<) && !exists($@) ]
	@if [ -f out/ghost/$*.c ] && [ ! -f $@ ]; then \
	echo; \
	echo "GHOST FILES DETECTED"; \
	echo "some .o files have no match in src/"; \
	echo "$$ diff <(find src -name "*.c" | sort) <(find out/ghost -type f | sed -e 's:^out/ghost:src:g' | sort)"; \
	echo "try using make clean to fix"; \
	echo; \
	exit 1; \
	fi

out/ghost/:
	mkdir -p $@

