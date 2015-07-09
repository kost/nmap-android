# Twese two usually works
HOSTARCH?="arm"
# HOSTPARM="--host=arm-linux"
HOSTPARM?="--host=arm-linux-androideabi"
#PREFIXT="mipsel-linux-android"
#PREFIXT="i686-linux-android"
PREFIXT?="arm-linux-androideabi"
# edit line below if you have NDK to reflect the path where NDK is installed
#NDK=/data/opt/android-ndk-r10d
#NDKDEST=/data/opt/ndk-$(HOSTARCH)
NDK=/tmp/android-ndk-r10d
NDKDEST=/tmp/ndk-$(HOSTARCH)
NDKPLATFORM?=android-9
ANDROIDDEST?=/sdcard/opt/nmap-6.47

# uncomment if you want openssl support and you have compiled OpenSSL already
# OPENSSLOPT="--with-openssl=/sd-ext/opt/openssl"
# OPENSSLOPT="--with-openssl=/sdcard/opt-$(HOSTARCH)/openssl"
OPENSSLOPT=

# only used for download and automatic extraction (getndk)
TMPNDK=/tmp/ndk.tar.bz2
TMPDIREXTRACT=/tmp


NDKCP=bash $(NDK)/build/tools/make-standalone-toolchain.sh --platform=$(NDKPLATFORM) --install-dir=$(NDKDEST) --arch=$(HOSTARCH)
NDKURL="http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86_64.tar.bz2"

all:
	@echo "Type 'make doit' to automatically download Android NDK and build"
	@echo "Type 'make havendk' to build automatically if you have NDK (edit Makefile!)"

doit: | getndk havendk
	@echo "Type 'doit' successfuly built"

getndk:
	wget $(NDKURL) -O $(TMPNDK) && cd $(TMPDIREXTRACT) && tar xvjf $(TMPNDK)
cpndk:
	$(NDKCP)

patch:
	-cd .. && patch -N -p1 < android/patches.diff

unpatch:
	-cd .. && patch -R -p1 < android/patches.diff

havendk: | cpndk patch build
	@echo "Type 'havendk' successfuly built"

build: | configure compile
	@echo "Type 'build' successfuly built"

configure:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) LUA_CFLAGS="-DLUA_USE_POSIX -fvisibility=default -fPIE" ac_cv_linux_vers=2 CC=$(PREFIXT)-gcc CXX=$(PREFIXT)-g++ LD=$(PREFIXT)-ld RANLIB=$(PREFIXT)-ranlib AR=$(PREFIXT)-ar STRIP=$(PREFIXT)-strip CFLAGS="-fvisibility=default -fPIE" CXXFLAGS="-fvisibility=default -fPIE" LDFLAGS="-rdynamic -pie" ./configure $(HOSTPARM) --without-zenmap --with-liblua=included --with-libpcap=internal --with-pcap=linux --enable-static --prefix=$(ANDROIDDEST) $(OPENSSLOPT)

	install:
		cd .. && PATH=$(NDKDEST)/bin:$(PATH) make install

compile:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) make

clean:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) make clean

cleanand: unpatch
	rm -rf $(NDKDEST)
