#!/bin/sh

set -x

ANDROIDDIR=/sdcard/opt
ANDROIDNMAP=nmap-7.12
NDKARCHPPREFIX=/data/opt/ndk
NDKPATH=/data/opt/android-ndk-r12b
CURDIR=`pwd`
NDK32LEVEL=9
NDK64LEVEL=21

echo "Patching..."
# make patch

echo "Starting Building for each arch"
#for arch in arm
#for arch in arm mipsel i686
for arch in arm mipsel i686 aarch64 mips64el x86_64
do
	echo "Building for $arch"
	OPENSSLPLATFORM=dist
	OPENSSLLDFLAGS="-static"
	NDKLEVEL=$NDK32LEVEL
	NDKPLATFORM=$arch
	if [ "$arch" = "arm" ]
	then
		THOSTPARM="--host=$arch-linux-androideabi"
		TPREFIXT="$arch-linux-androideabi"
		ARCHZIP="armeabi"
	elif [ "$arch" = "aarch64" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="aarch64"
		NDKPLATFORM=arm64
		NDKLEVEL=$NDK64LEVEL
	elif [ "$arch" = "mipsel" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="mips"
		NDKPLATFORM=mips
	elif [ "$arch" = "mips64el" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="mips64el"
		NDKPLATFORM=mips64
		NDKLEVEL=$NDK64LEVEL
	elif [ "$arch" = "i686" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="x86"
		NDKPLATFORM=x86
	elif [ "$arch" = "x86_64" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="x86_64"
		OPENSSLPLATFORM=linux-x86_64
		OPENSSLLDFLAGS=
		NDKLEVEL=$NDK64LEVEL
	else
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="dunno"
	fi

	NDKARCHPATH=$NDKARCHPPREFIX-$arch
	$NDKPATH/build/tools/make_standalone_toolchain.py --arch $NDKPLATFORM --api $NDKLEVEL --stl libc++ --force --install-dir $NDKARCHPATH
	if [ $? -eq 0 ]; then
		echo "[i] Successful copying of standalone toolchain"
	else
		echo "[!] Error copying of standalone toolchain"
		exit 1
	fi
	NDK=$NDKPATH PATH=$NDKARCHPATH/bin:$PATH NDKDEST=$NDKARCHPATH ANDROIDDEST=$ANDROIDDIR/$ANDROIDNMAP HOSTARCH=$arch HOSTPARM=$THOSTPARM PREFIXT=$TPREFIXT OPENSSL=1 OPENSSLPLATFORM=$OPENSSLPLATFORM OPENSSLLDFLAGS= make openssl build install strip
	if [ $? -eq 0 ]; then
		echo "[i] Successful compilation of $arch"
	else
		echo "[!] Error compilation of $arch"
		exit 1
	fi

	echo "Copying data"

	cd $ANDROIDDIR/$ANDROIDNMAP

	cp -a bin/ /tmp/$ANDROIDNMAP-$arch
	# PATH=$NDKARCHPATH/bin:$PATH $TPREFIXT-strip bin/*
	cd bin
	zip -9 ../../$ANDROIDNMAP-binaries-$ARCHZIP.zip * 
	cd ..

	cd ..
	# build data zip only once (arm is fine)
	if [ "$arch" = "arm" ]
	then
		zip -r -9 $ANDROIDNMAP-data.zip $ANDROIDNMAP/lib $ANDROIDNMAP/share
	fi

	tar cvjf $ANDROIDNMAP-android-$arch-bin.tar.bz2 $ANDROIDNMAP/
	cd $CURDIR

	echo "Cleaning up"
	make clean
	echo rm -rf $ANDROIDDIR/$ANDROIDNMAP
	echo "Finished"
done

