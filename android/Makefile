# Twese two usually works
HOSTARCH?="arm"
# HOSTPARM="--host=arm-linux"
HOSTPARM?="--host=arm-linux-androideabi"
#PREFIXT="mipsel-linux-android"
#PREFIXT="i686-linux-android"
PREFIXT?="arm-linux-androideabi"
# edit line below if you have NDK to reflect the path where NDK is installed
NDK?=/tmp/android-ndk-r11c
NDKDEST?=/tmp/ndk-$(HOSTARCH)
NDKLEVEL?=9
NDKPLATFORM?=android-$(NDKLEVEL)
ANDROIDDEST?=/sdcard/opt/nmap-7.31
OPENSSLPLATFORM?=dist
OPENSSLLDFLAGS?="-static"

ifdef OPENSSL
OPENSSLVER?=openssl-1.0.2j
OPENSSLURL?="https://openssl.org/source/$(OPENSSLVER).tar.gz"
OPENSSLDIR?=/sdcard/opt-$(HOSTARCH)/$(OPENSSLVER)
OPENSSLOPT?="--with-openssl=$(OPENSSLDIR)"
else
OPENSSLOPT?=""
endif

# only used for download and automatic extraction (getndk)
TMPNDK=/tmp/ndk.tar.bz2
TMPDIREXTRACT=/tmp

NDKCP=$(NDK)/build/tools/make_standalone_toolchain.py --arch $(HOSTARCH) --api $(NDKLEVEL) --stl libc++ --force --install-dir=$(NDKDEST) 
NDKURL="https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip"

all:
	@echo "Type 'make doit' to automatically download Android NDK and build"
	@echo "Type 'make havendk' to build automatically if you have NDK (check Makefile!)"
	@echo "For example: make havendk NDK=/data/opt/android-ndk-r11"

doit: | getndk havendk
	@echo "Type 'doit' successfuly built"

getndk:
	wget $(NDKURL) -O $(TMPNDK) && cd $(TMPDIREXTRACT) && unzip $(TMPNDK)

cpndk:
	$(NDKCP)

openssl: 
	cd ../.. && wget -nc $(OPENSSLURL) && tar xvzf $(OPENSSLVER).tar.gz
	# cd ../../$(OPENSSLVER) && PATH=$(NDKDEST)/bin:$(PATH) CC=$(PREFIXT)-gcc AR="$(PREFIXT)-ar r" RANLIB=$(PREFIXT)-ranlib LDFLAGS="-static" ./Configure $(OPENSSLPLATFORM) --prefix=$(OPENSSLDIR) 
	cd ../../$(OPENSSLVER) && PATH=$(NDKDEST)/bin:$(PATH) CC=$(PREFIXT)-gcc AR="$(PREFIXT)-ar r" RANLIB=$(PREFIXT)-ranlib LDFLAGS=$(OPENSSLLDFLAGS) ./Configure $(OPENSSLPLATFORM) --prefix=$(OPENSSLDIR) 
	cd ../../$(OPENSSLVER) && PATH=$(NDKDEST)/bin:$(PATH) make clean
	cd ../../$(OPENSSLVER) && PATH=$(NDKDEST)/bin:$(PATH) make CC=$(PREFIXT)-gcc AR="$(PREFIXT)-ar r" RANLIB=$(PREFIXT)-ranlib LDFLAGS=$(OPENSSLLDFLAGS)
	cd ../../$(OPENSSLVER) && PATH=$(NDKDEST)/bin:$(PATH) make install
	
patch:
	-cd .. && for patchfile in android/patches/*.diff; do echo processing patch $$patchfile; patch -N -p1 < $$patchfile ; done

unpatch:
	-cd .. && for patchfile in android/patches/*.diff; do echo reversing patch $$patchfile; patch -R -p1 < $$patchfile ; done

havendk: | cpndk patch build
	@echo "Type 'havendk' successfuly built"

build: | configure compile
	@echo "Type 'build' successfuly built"

configure:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) LUA_CFLAGS="-DLUA_USE_POSIX -fvisibility=default -fPIE" ac_cv_linux_vers=2 CC=$(PREFIXT)-gcc CXX=$(PREFIXT)-g++ LD=$(PREFIXT)-ld RANLIB=$(PREFIXT)-ranlib AR=$(PREFIXT)-ar STRIP=$(PREFIXT)-strip CFLAGS="-fvisibility=default -fPIE" CXXFLAGS="-fvisibility=default -fPIE" LDFLAGS="-rdynamic -pie -static-libstdc++" ./configure $(HOSTPARM) --without-zenmap --with-liblua=included --with-libpcap=internal --with-pcap=linux --enable-static --disable-rpath --prefix=$(ANDROIDDEST) $(OPENSSLOPT)

install:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) make install

strip: install
	-cd .. && PATH=$(NDKDEST)/bin:$(PATH) $(PREFIXT)-strip $(ANDROIDDEST)/bin/*
	echo "Success (ignore any strip errors!)"

compile:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) make

clean:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) make clean

cleanand: unpatch
	rm -rf $(NDKDEST)
