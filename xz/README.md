# xz

## Cross
Disable pgo-build for cross xz:
```C
make[3]: Leaving directory '/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests'
make -j12 V=1  check-TESTS
make[3]: Entering directory '/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests'
make[3]: warning: -jN forced in submake: disabling jobserver mode.
./test_check: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/test_check: No such file or directory
FAIL: test_check
./test_stream_flags: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/test_stream_flags: No such file or directory
FAIL: test_stream_flags
./test_filter_flags: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/test_filter_flags: No such file or directory
FAIL: test_filter_flags
./test_block_header: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/test_block_header: No such file or directory
FAIL: test_block_header
./test_index: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/test_index: No such file or directory
FAIL: test_index
./test_bcj_exact_size: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/test_bcj_exact_size: No such file or directory
FAIL: test_bcj_exact_size
../src/xz/xz: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/src/xz/.libs/xz: No such file or directory
Good file failed: ./files/good-0-empty.xz
FAIL: test_files.sh
./create_compress_files: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/.libs/create_compress_files: No such file or directory
Failed to create files to test compression.
FAIL: test_compress.sh
/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/../src/xz/xz: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/src/xz/.libs/xz: No such file or directory
/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests/../src/xz/xz: line 117: /home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/src/xz/.libs/xz: No such file or directory
xzdiff with no changes exited with status 2 != 0
FAIL: test_scripts.sh
=========================================
9 of 9 tests failed
Please report to lasse.collin@tukaani.org
=========================================
make[3]: *** [Makefile:605: check-TESTS] Error 1
make[3]: Leaving directory '/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests'
make[2]: *** [Makefile:732: check-am] Error 2
make[2]: Leaving directory '/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz/tests'
make[1]: *** [Makefile:619: check-recursive] Error 1
make[1]: Leaving directory '/home/firasuke/Downloads/Git/glaucus/temporary/cross/sources/xz'
make: *** [Makefile:1093: pgo-build] Error 2
-- ceras xz: build exited with status 2
```
