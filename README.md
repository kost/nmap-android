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
make havendk NDK=/opt/android-ndk-r10d
```

Transfer binaries and supporting files to android (adb, wireless, ...)

Have fun!

