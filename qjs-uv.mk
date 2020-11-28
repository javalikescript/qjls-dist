LIBNAME = uv
TARGET = $(LIBNAME).$(SO)

LIB_UV_PATH = libuv

include ../def.mk

CFLAGS_dll = $(DEF_CFLAGS_WINDOWS) \
	-Wextra \
	-Wno-unused-parameter \
	-Wstrict-prototypes \
	-I$(LIB_UV_PATH)/include \
	-D_WIN32_WINNT=0x0600 \
	-DBUILDING_UV_SHARED \
	-Dluv_EXPORTS

LIBOPT_dll = $(LIB_UV_PATH)/libuv.a $(DEF_LIBOPT_WINDOWS) \
	-lws2_32 -lpsapi -liphlpapi -lshell32 -luserenv -luser32

CFLAGS_so = $(DEF_CFLAGS_LINUX) \
	-I$(LIB_UV_PATH)/include \
	-std=gnu99 \
	-DBUILDING_UV_SHARED \
	-D_FILE_OFFSET_BITS=64  \
	-D_GNU_SOURCE  \
	-D_LARGEFILE_SOURCE \
	-Dluv_EXPORTS \
	-pthread

LIBOPT_so = $(LIB_UV_PATH)/libuv.a $(DEF_LIBOPT_LINUX) \
	-lrt -pthread -lpthread

LIBOPT = $(LIBOPT_$(SO))
CFLAGS += $(CFLAGS_$(SO))

OBJS = $(LIBNAME).o

SRCS = $(LIBNAME).c

lib: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LIBOPT) -o $(TARGET)

clean:
	-$(RM) $(OBJS) $(TARGET)

$(OBJS): %.o : %.c $(SRCS)
	$(CC) $(CFLAGS) -c -o $@ $<
