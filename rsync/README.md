# rsync

## Cross
simd optimizations need to be disabled (using `--disable-simd`) when cross
compiling rsync:

```C
checking whether to enable SIMD optimizations... configure.sh: error: in `/home/firasuke/Downloads/Git/glaucus/tmp/cross/src/rsync':
```

## Chroot

requires `yodl` to be installed on the host system

`rsync` is needed by all ceras scripts in chroot, and is also needed by linux's
`make install`
