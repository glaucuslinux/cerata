# libcap
## Cross
### Configure
libcap doesn't cross build without disabling tests.

Providing CROSS_COMPILE as an env var works fine, so there's no need to pass it
again here.

## System
### Configure
Newer versions of libcap don't need the removal of the static library build
and RAISE_SETFCAP is set to `no` by default now.
