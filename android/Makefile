# edit line below if you have NDK to reflect the path where NDK is installed
NDK=/tmp/android-ndk-r7
NDKDEST=/tmp/ndk
NDKPLATFORM=android-5
ANDROIDDEST=/sdcard/opt/nmap-6.25

OPENSSLOPT=
# uncomment if you want openssl support and you have compiled OpenSSL already
# OPENSSLOPT="--with-openssl=/sd-ext/opt/openssl"

# only used for download and automatic extraction (getndk)
TMPNDK=/tmp/ndk.tar.bz2
TMPDIREXTRACT=/tmp

# Twese two usually works
HOSTPARM="--host=arm-linux"
# HOSTPARM="--host=arm-linux-androideabi"

NDKCP=$(NDK)/build/tools/make-standalone-toolchain.sh --platform=$(NDKPLATFORM) --install-dir=$(NDKDEST)
NDKURL="http://dl.google.com/android/ndk/android-ndk-r5b-linux-x86.tar.bz2"

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
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) LUA_CFLAGS="-DLUA_USE_POSIX" LDFLAGS="-static" ac_cv_linux_vers=2 CC=arm-linux-androideabi-gcc CXX=arm-linux-androideabi-g++ LD=arm-linux-androideabi-ld RANLIB=arm-linux-androideabi-ranlib AR=arm-linux-androideabi-ar STRIP=arm-linux-androideabi-strip ./configure $(HOSTPARM) --without-zenmap --with-liblua=included --with-libpcap=internal --with-pcap=linux --enable-static --prefix=$(ANDROIDDEST) $(OPENSSLOPT)

compile:
	cd .. && PATH=$(NDKDEST)/bin:$(PATH) make

clean: unpatch
	rm -rf $(NDKDEST)
