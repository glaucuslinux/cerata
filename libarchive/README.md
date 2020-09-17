# libarchive

## Cross
Doesn't build with attr and acl when cross compiled (detects wrong .la files
from the host). This won't be a problem because it will have both attr and acl
enabled on the final system.

## Chroot
Requires both zlib and xz to be built beforehand to make use of them
