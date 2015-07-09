#!/bin/sh

set -x

ANDROIDDIR=/sdcard/opt
ANDROIDNMAP=nmap-6.47
NDKARCHPPREFIX=/data/opt/ndk
CURDIR=`pwd`

echo "Patching..."
# make patch

echo "Starting Building for each arch"
for arch in arm mipsel i686
do
	echo "Building for $arch"
	if [ "$arch" = "arm" ]
	then
		THOSTPARM="--host=$arch-linux-androideabi"
		TPREFIXT="$arch-linux-androideabi"
		ARCHZIP="armeabi"
	elif [ "$arch" = "mipsel" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="mips"
	elif [ "$arch" = "i686" ]
	then
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="x86"
	else
		THOSTPARM="--host=$arch-linux-android"
		TPREFIXT="$arch-linux-android"
		ARCHZIP="dunno"
	fi
	NDKARCHPATH=$NDKARCHPPREFIX-$arch
	PATH=$NDKARCHPATH/bin:$PATH NDKDEST=$NDKARCHPATH ANDROIDDEST=$ANDROIDDIR/$ANDROIDNMAP HOSTARCH=$arch HOSTPARM=$THOSTPARM PREFIXT=$TPREFIXT make build install strip
	echo "Copying data"

	cd $ANDROIDDIR/$ANDROIDNMAP
	PATH=$NDKARCHPATH/bin:$PATH $TPREFIXT-strip bin/*
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

