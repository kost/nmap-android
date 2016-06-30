nmap-android
============

Nmap on Android - Makefile/diff/scripts to build it with Android NDK

Put android/ directory to nmap source root.

Go to android directory and say:
```
make doit
```

Or if you have Android NDK already, just specify NDK location and
issue following command:
```
make havendk NDK=/opt/android-ndk-r12b
```

Transfer binaries and supporting files to android (adb, wireless, ...)


### OpenSSL support

```
make openssl havendk OPENSSL=1 NDK=/opt/android-ndk-r12b
```

Have fun!


### NDK Custom builds

In case you already have NDK and you already have NDK copied:

```
make NDK=/data/opt/android-ndk-r12b NDKDEST=/data/opt/ndk-arm OPENSSL=1 openssl build install strip
```

