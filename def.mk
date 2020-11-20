DEF_CFLAGS_LINUX = -g -Wall -Wno-array-bounds -Wno-format-truncation \
  -D_GNU_SOURCE -DCONFIG_VERSION=\"2020-11-08\" -DCONFIG_BIGNUM \
  -O2 -flto -fPIC -DJS_SHARED_LIBRARY \
  -I../$(QJS_PATH)

DEF_LIBOPT_LINUX = -g -flto -shared

DEF_CFLAGS_WINDOWS = -g -Wall -Wno-array-bounds -Wno-format-truncation \
  -D_GNU_SOURCE -DCONFIG_VERSION=\"2020-11-08\" -DCONFIG_BIGNUM -D__USE_MINGW_ANSI_STDIO \
  -O2 -flto -fPIC -DJS_SHARED_LIBRARY \
  -I../$(QJS_PATH)

DEF_LIBOPT_WINDOWS = -g -flto -shared \
  -L..\$(QJS_PATH) -lquickjs
