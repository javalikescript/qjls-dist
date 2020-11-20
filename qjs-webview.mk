LIBNAME = webview
TARGET = $(LIBNAME).$(SO)

WEBVIEW_C = webview-c
MS_WEBVIEW2 = $(WEBVIEW_C)/ms.webview2

GCC_NAME ?= $(shell $(CC) -dumpmachine)
WEBVIEW_ARCH = x64
ifeq (,$(findstring x86_64,$(GCC_NAME)))
  WEBVIEW_ARCH = x86
endif

include ../def.mk

CFLAGS_dll = $(DEF_CFLAGS_WINDOWS) \
  -DWEBVIEW_WINAPI=1 \
  -I$(WEBVIEW_C) -I$(MS_WEBVIEW2)/include

LIBOPT_dll = $(DEF_LIBOPT_WINDOWS) \
  -lole32 -lcomctl32 -loleaut32 -luuid -lgdi32

CFLAGS_so = $(DEF_CFLAGS_LINUX) \
  -I$(WEBVIEW_C) \
  -DWEBVIEW_GTK=1 \
  $(shell pkg-config --cflags gtk+-3.0 webkit2gtk-4.0)

LIBOPT_so = $(DEF_LIBOPT_LINUX) \
  $(shell pkg-config --libs gtk+-3.0 webkit2gtk-4.0)

LIBOPT = $(LIBOPT_$(SO))
CFLAGS += $(CFLAGS_$(SO))
SOURCES = webview.c
OBJS = webview.o

SRCS = $(WEBVIEW_C)/webview.h \
  $(WEBVIEW_C)/webview-cocoa.c \
  $(WEBVIEW_C)/webview-gtk.c \
  $(WEBVIEW_C)/webview-win32.c \
  $(WEBVIEW_C)/webview-win32-edge.c

lib: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LIBOPT) -o $(TARGET)

clean:
	-$(RM) $(OBJS) $(TARGET)

$(OBJS): %.o : %.c $(SOURCES) $(SRCS)
	$(CC) $(CFLAGS) -c -o $@ $<
