# pciutils
## Cross
### Configure
We need to pass CROSS_COMPILE even though we have it setup in our env vars,
otherwise it won't be detected and it'll resort to a native build and won't find
kmod.h
