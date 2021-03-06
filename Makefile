MK_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MK_DIR := $(dir $(MK_PATH))

ARCH = x86_64

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	PLAT ?= linux
else
	PLAT ?= windows
endif

MAIN_TARGET = core

QJS_PATH := quickjs

SO_windows=dll
EXE_windows=.exe
MK_windows=main_mingw.mk
TGZ_windows=.zip

SO_linux=so
EXE_linux=
MK_linux=main_linux.mk
TGZ_linux=.tar.gz

SO := $(SO_$(PLAT))
EXE := $(EXE_$(PLAT))
MAIN_MK := $(MK_$(PLAT))
TGZ := $(TGZ_$(PLAT))

GCC_NAME ?= $(shell $(CROSS_PREFIX)gcc -dumpmachine)
QJS_APP = $(QJS_PATH)/qjs$(EXE)
QJS_DATE = $(shell date '+%Y%m%d')
QJS_VERSION = $(shell cat $(QJS_PATH)/VERSION)
DIST_SUFFIX ?= -$(GCC_NAME).$(QJS_DATE)
DIST = dist

WEBVIEW_ARCH = x64
ifeq (,$(findstring x86_64,$(GCC_NAME)))
  WEBVIEW_ARCH = x86
endif

ifdef HOST
	CROSS_PREFIX ?= $(HOST)-
	ifneq (,$(findstring arm,$(HOST)))
		ARCH = arm
	endif
	CROSS_DEFS = CROSS_PREFIX=$(CROSS_PREFIX)
endif

ifneq ($(QJS_OPENSSL_LINKING),dynamic)
	QJS_OPENSSL_LINKING = static
endif

all: qjs qjs-uv qjs-webview

other:
	@$(MAKE) PLAT=$(PLAT) MAIN_TARGET=$@ main

help:
	@echo Main targets \(MAIN_TARGET\): all
	@echo Other targets: configure clean dist help
	@echo Available platforms \(PLAT\): linux windows
	@echo Available architecture \(ARCH\): x86_64 arm

show:
	@echo Make command goals: $(MAKECMDGOALS)
	@echo TARGET: $@
	@echo ARCH: $(ARCH)
	@echo HOST: $(HOST)
	@echo PLAT: $(PLAT)
	@echo GCC_NAME: $(GCC_NAME)
	@echo QJS_PATH: $(QJS_PATH)
	@echo QJS_VERSION: $(QJS_VERSION)
	@echo Library extension: $(SO)
	@echo CC: $(CC)
	@echo AR: $(AR)
	@echo RANLIB: $(RANLIB)
	@echo LD: $(LD)
	@echo MK_DIR: $(MK_DIR)

MAIN_VARS = PLAT=$(PLAT) \
		QJS_PATH=$(QJS_PATH) \
		SO=$(SO) \
		ARCH=$(ARCH) \
		HOST=$(HOST) \
		CC=$(CROSS_PREFIX)gcc \
		AR=$(CROSS_PREFIX)ar \
		RANLIB=$(CROSS_PREFIX)ranlib \
		LD=$(CROSS_PREFIX)gcc

configure:

qjs: qjs-$(PLAT)

qjs-linux:
	@$(MAKE) -C $(QJS_PATH) qjs CFLAG_DEBUG= NO_WORKER=y "LDEXPORT=-rdynamic -static-libgcc" $(CROSS_DEFS)

qjs-windows:
	@$(MAKE) -C $(QJS_PATH) qjs.exe libquickjs.a libquickjs.lto.a CONFIG_WIN32=y CFLAG_DEBUG= NO_WORKER=y CROSS_PREFIX= LDEXPORT=-static-libgcc

qjs-webview: qjs
	$(MAKE) -C $@ -f ../$@.mk $(MAIN_VARS)

qjs-sample: qjs
	$(MAKE) -C $@ -f ../mod.mk LIBNAME=sample $(MAIN_VARS)

libuv:
	$(MAKE) -C qjs-uv/libuv -f ../../libuv_$(PLAT).mk CC=$(CC)

qjs-uv: qjs libuv
	$(MAKE) -C $@ -f ../$@.mk LIBNAME=tuv $(MAIN_VARS)


clean-qjs:
	@$(MAKE) -C $(QJS_PATH) clean

clean-qjs-libs:
	-$(RM) ./qjs-uv/*.o
	-$(RM) ./qjs-uv/*.$(SO)
	-$(RM) ./qjs-webview/*.o
	-$(RM) ./qjs-webview/*.$(SO)

clean-libuv:
	-$(RM) ./qjs-uv/libuv/*.a
	-$(RM) ./qjs-uv/libuv/src/*.o
	-$(RM) ./qjs-uv/libuv/src/unix/*.o
	-$(RM) ./qjs-uv/libuv/src/win/*.o

clean-libs: clean-libuv

clean: clean-qjs clean-qjs-libs

clean-all: clean clean-libs

clean-dist:
	rm -rf $(DIST)

dist-prepare:
	-mkdir $(DIST)

dist-copy-linux:

dist-copy-windows:
	-cp -u qjs-webview/webview-c/ms.webview2/$(WEBVIEW_ARCH)/WebView2Loader.dll $(DIST)/

dist-copy: dist-copy-$(PLAT)
	cp -u $(QJS_PATH)/qjs$(EXE) $(DIST)/
	-cp -u qjs-webview/webview.$(SO) $(DIST)/
	-cp -u qjs-uv/tuv.$(SO) $(DIST)/

dist: clean-dist dist-prepare dist-copy


qjls.tar.gz:
	cd $(DIST) && tar --group=jls --owner=jls -zcvf qjls$(DIST_SUFFIX).tar.gz *

qjls.zip:
	cd $(DIST) && zip -r qjls$(DIST_SUFFIX).zip *

qjls-archive: qjls$(TGZ)

release: dist qjls-archive

.PHONY: clean linux windows qjs qjs-webview qjs-uv
