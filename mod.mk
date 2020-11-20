LIBNAME = libname
TARGET = $(LIBNAME).$(SO)

include ../def.mk

CFLAGS_dll = $(DEF_CFLAGS_WINDOWS)
LIBOPT_dll = $(DEF_LIBOPT_WINDOWS)

CFLAGS_so = $(DEF_CFLAGS_LINUX)
LIBOPT_so = $(DEF_LIBOPT_LINUX)

CFLAGS += $(CFLAGS_$(SO))
LIBOPT = $(LIBOPT_$(SO))

SOURCES = $(LIBNAME).c
OBJS = $(LIBNAME).o

lib: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LIBOPT) -o $(TARGET)

clean:
	-$(RM) $(OBJS) $(TARGET)

$(OBJS): %.o : %.c $(SOURCES)
	$(CC) $(CFLAGS) -c -o $@ $<
