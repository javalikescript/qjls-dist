CFLAGS_DEBUG = -O

DEF_CFLAGS_LINUX = $(CFLAGS_DEBUG) -Wall -Wno-array-bounds -Wno-format-truncation \
  -D_GNU_SOURCE -DCONFIG_VERSION=\"2020-11-08\" -DCONFIG_BIGNUM \
  -O2 -flto -fPIC -DJS_SHARED_LIBRARY \
  -I../$(QJS_PATH)

DEF_LIBOPT_LINUX = $(CFLAGS_DEBUG) -flto -shared \
	-static-libgcc -Wl,-s \

DEF_CFLAGS_WINDOWS = $(CFLAGS_DEBUG) -Wall -Wno-array-bounds -Wno-format-truncation \
  -D_GNU_SOURCE -DCONFIG_VERSION=\"2020-11-08\" -DCONFIG_BIGNUM -D__USE_MINGW_ANSI_STDIO \
  -O2 -flto -fPIC -DJS_SHARED_LIBRARY \
  -I../$(QJS_PATH)

DEF_LIBOPT_WINDOWS = $(CFLAGS_DEBUG) -flto -shared \
	-static-libgcc -Wl,-s \
  -L..\$(QJS_PATH) -lquickjs
