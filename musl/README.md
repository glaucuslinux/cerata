# musl
## Native
### Native Configure
Tread with care as the destination directories for some of these options
are tricky.

Specifying --prefix alone will install everything into that directory and
will attempt to link the libc.so installed there to a system wide linker in
/lib.
So (prefix alone | installs/libc.so in $PREFIX | linker (to OUR $PREFIX
libc.so) in host's /lib and needs sudo because of that)

Specifying $DESTDIR with make install, and --prefix here (don't forget
the trailing slash if you intend to use both of them) will install
everything into $DESTDIR$PREFIX (yup, there exists no forward slash between
these two so be careful). This will also symlink the libc.so residing in
$DESTDIR$PREFIX to $DESTDIR alone.
So (prefix + destdir | installs/libc in $DESTDIR$PREFIX | linker (to OUR 
$PREFIX libc.so even though the relative path is wrong) in DESTDIR) so no
sudo required

Specifying --prefix and --syslibdir, will get musl installed (+ libc.so) in
--prefix as intended and will get the tricky linker installed in the host's
/usr/lib (which is why make install requires sudo). This is easier to
manage especially if the distribution is glibc based, as it makes it easier
for target executables to find the path of the linker on the host and on
the system (when separately booting) as they share the same path /usr/lib.
Although this makes it easier to build without chrooting, chrooting is still
required, and this whole approach might be changed, as the graphics stack
is very picky about its libdirs.

wrongly passing `--prefix` as `--prefix=$CRSS` will cause problems such as
isl not finding libgmp.so and zstd complaining of missing header files such
as `string.h`...

CROSS_COMPILE can be removed if --host is detected correctly as $TUPL,
otherwise leave it here.

Remove both the symlink to the original Makefile and the system's musl
dynamic linker (this is dangerous if you're already running a musl based
distribution as it's assumed that the host is using glibc, so this shouldn't
exist in the first place).

We then copy the original makefile, and prefix the command responsible
for creating the dyanmic linker with sudo so that it installs in /usr/lib
(this is the intended behaviour since our host uses glibc so it won't
overwrite any existing musl dynamic linker, and it makes it possible to
build without chrooting, so this will changed later as glaucus' graphics
stack requires a separate chroot)

Tread with care as the destination directories for some of these options
are tricky.

Specifying --prefix alone will install everything into that directory and
will attempt to link the libc.so installed there to a system wide linker in
/lib.
So (prefix alone | installs/libc.so in $PREFIX | linker (to OUR $PREFIX
libc.so) in host's /lib and needs sudo because of that)

Specifying $DESTDIR with make install, and --prefix here (don't forget
the trailing slash if you intend to use both of them) will install
everything into $DESTDIR$PREFIX (yup, there exists no forward slash between
these two so be careful). This will also symlink the libc.so residing in
$DESTDIR$PREFIX to $DESTDIR alone.
So (prefix + destdir | installs/libc in $DESTDIR$PREFIX | linker (to OUR 
$PREFIX libc.so even though the relative path is wrong) in DESTDIR) so no
sudo required

Specifying --prefix and --syslibdir, will get musl installed (+ libc.so) in
--prefix as intended and will get the tricky linker installed in the host's
/usr/lib (which is why make install requires sudo). This is easier to
manage especially if the distribution is glibc based, as it makes it easier
for target executables to find the path of the linker on the host and on
the system (when separately booting) as they share the same path /usr/lib.
Although this makes it easier to build without chrooting, chrooting is still
required, and this whole approach might be changed, as the graphics stack
is very picky about its libdirs.

Remove both the symlink to the original Makefile and the system's musl
dynamic linker (this is dangerous if you're already running a musl based
distribution as it's assumed that the host is using glibc, so this shouldn't
exist in the first place).

We then copy the original makefile, and prefix the command responsible
for creating the dyanmic linker with sudo so that it installs in /usr/lib
(this is the intended behaviour since our host uses glibc so it won't
overwrite any existing musl dynamic linker, and it makes it possible to
build without chrooting, so this will changed later as glaucus' graphics
stack requires a separate chroot)

### Native Install
Don't delete `include/utmp.h` and `include/utmpx.h` from native musl because
that'll cause chroot toybox to complain about missing utmp and utmpx because
some tools use it:

<https://github.com/landley/toybox/issues/185>

Even after successfully configuring toybox to not use utmp and utmpx, some
software like who and whoami from toybox when disabled cause autotools to
complain when autoreconfing anything (similar to the m4 Error end of file in
string), so don't remove utmp.h/utmpx.h from native musl.

## System
### System Configure

CFLAGS are passed to configure and not as an environment variable.

musl doesn't build with LTO enabled, which is shocking but true.

here --prefix and --syslibdir are both given, since DESTDIR is also given
this will produce the intended effect of being installed similary to all
other cerata, however the resulting dynamic linker will be messed up and
probably will point to the wrong path, but this is easily fixable.

Remove both the symlink to the original Makefile and the system's musl
dynamic linker (this is dangerous if you're already running a musl based
distribution as it's assumed that the host is using glibc, so this shouldn't
exist in the first place).

We then copy the original makefile, and modify the command responsible
for wrongly linking the resulting dynamic linker with the wrong libc.so, so
that the dynamic linker it links to the resulting libc.so is located in the
exact same location of the libc.so

### System Build
Doesn't build with `-flto`:
```C
/sources/musl/musl-1.1.24/src/thread/pthread_create.c:210:1: warning: type of '__pthread_tsd_main' does not match original declaration [-Wlto-type-mismatch]
  210 | weak_alias(dummy_tsd, __pthread_tsd_main);
      | ^
/sources/musl/musl-1.1.24/src/thread/pthread_key_create.c:4:7: note: array types have different bounds
    4 | void *__pthread_tsd_main[PTHREAD_KEYS_MAX] = { 0 };
      |       ^
/sources/musl/musl-1.1.24/src/thread/pthread_key_create.c:4:7: note: '__pthread_tsd_main' was previously declared here
/toolchain/lib/gcc/x86_64-pc-linux-musl/9.2.0/../../../../x86_64-pc-linux-musl/bin/ld: /tmp/libc.so.CLKaIL.ltrans0.ltrans.o: in function `_dlstart':
<artificial>:(.text+0x12): undefined reference to `_dlstart_c'
collect2: error: ld returned 1 exit status
make: *** [Makefile:160: lib/libc.so] Error 1
```

Doesn't build with `-flto -ffat-lto-objects`:
```C
/sources/musl/musl-1.1.24/src/thread/pthread_create.c:210:1: warning: type of '__pthread_tsd_main' does not match original declaration [-Wlto-type-mismatch]
  210 | weak_alias(dummy_tsd, __pthread_tsd_main);
      | ^
/sources/musl/musl-1.1.24/src/thread/pthread_key_create.c:4:7: note: array types have different bounds
    4 | void *__pthread_tsd_main[PTHREAD_KEYS_MAX] = { 0 };
      |       ^
/sources/musl/musl-1.1.24/src/thread/pthread_key_create.c:4:7: note: '__pthread_tsd_main' was previously declared here
/toolchain/lib/gcc/x86_64-pc-linux-musl/9.2.0/../../../../x86_64-pc-linux-musl/bin/ld: /tmp/libc.so.deGbKp.ltrans0.ltrans.o: in function `_dlstart':
<artificial>:(.text+0x12): undefined reference to `_dlstart_c'
collect2: error: ld returned 1 exit status
make: *** [Makefile:160: lib/libc.so] Error 1
```

Doesn't build with `-mfpmath=both`:
```C
generic -Iobj/src/internal -I/sources/musl/musl-1.1.24/src/include -I/sources/musl/musl-1.1.24/src/internal -Iobj/include -I/sources/musl/musl-1.1.24/include  -pipe -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections -Werror=implicit-function-declaration -Werror=implicit-int -Werror=pointer-sign -Werror=pointer-arith -pipe -fopenmp -g0 -Ofast -fmodulo-sched -fmodulo-sched-allow-regmoves -fgcse-sm -fgcse-las -fira-loop-pressure -fipa-pta -fgraphite-identity -floop-nest-optimize -fmerge-all-constants -fdevirtualize-at-ltrans -fno-semantic-interposition -fvariable-expansion-in-unroller -ftracer -funroll-loops -s -fno-common -fno-plt -march=x86-64 -mtls-dialect=gnu2 -mfpmath=both -malign-data=cacheline -fPIC -c -o obj/src/math/__rem_pio2.lo /sources/musl/musl-1.1.24/src/math/__rem_pio2.c
/sources/musl/musl-1.1.24/src/math/__rem_pio2.c:38:15: error: 'EPS' undeclared here (not in a function)
   38 | toint   = 1.5/EPS,
      |               ^~~
make: *** [Makefile:157: obj/src/math/__rem_pio2.lo] Error 1
```

Shouldn't be built with `-malign-data=cacheline` and causes this weird m4 error
(ERROR: end of file in argument list) due to `autoconf`'s wrong (unparseable
output) when checked with `autoconf -v`:
```C
autoreconf: Entering directory `.'
autoreconf: configure.ac: not using Gettext
autoreconf: running: aclocal --force -I m4
autoreconf: configure.ac: tracing
autoreconf: configure.ac: not using Libtool
autoreconf: running: /usr/bin/autoconf --force
autoreconf: configure.ac: not using Autoheader
autoreconf: configure.ac: not using Automake
autoreconf: Leaving directory `.'
configure: WARNING: libattr development library was not found or not usable.
configure: WARNING: GNU patch will be built without xattr support.
m4:/tmp/am4tJkeFDJ/traces.m4:293: ERROR: end of file in argument list
configure.ac: error: no proper invocation of AM_INIT_AUTOMAKE was found.
configure.ac: You should verify that configure.ac invokes AM_INIT_AUTOMAKE,
configure.ac: that aclocal.m4 is present in the top-level directory,
configure.ac: and that aclocal.m4 was recently regenerated (using aclocal)
automake-1.16: error: no 'Makefile.am' found for any configure output
automake-1.16: Did you forget AC_CONFIG_FILES([Makefile]) in configure.ac?
make: *** [Makefile:1231: Makefile.in] Error 1
```
### Install

we then create a symlink to the dyanimc linker called ldd (list dynamic
dependencies)

and finish it off with stripping some resulting unstripped files
we can also further remove all resulting `*.a` files, but those were left
for compatibility purposes, and hopefully will soon be removed if everything
builds fine without them

Don't symlink ldconfig to toybox's true as toybox won't recognize ldconfig,
instead create an ldconfig script with true in it

Musl's regex doesn't support GNU regex functions, so we can't use the flag
`--without-included-regex` on several of the GNU packages, so we default to
their already included GNU regex that has GNU regex functions... (Does uclibc-ng
do the same as well?)
