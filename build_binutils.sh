#!/bin/bash
# https://www.nongnu.org/avr-libc/user-manual/install_tools.html#install_avr_binutils

# Make AVR-Binutils
MYNAME="binutils"
echo "\n*** Making ${MYNAME} ***\n"

# Handle cache
$PREFIX/bin/avr-objdump --version || true
IS_BINUTILS=$($PREFIX/bin/avr-objdump --version | sed -n "/${VER_BINUTILS}/p")
if [ -n "$IS_BINUTILS" ] ; then
  echo "\n  --> ${MYNAME} is already OK for version ${VER_BINUTILS} --> We will not build it.\n"
  exit 0
fi

echo "\n\nDownloading and extracting ${MYNAME} ...\n"
wget http://ftp.gnu.org/gnu/binutils/${BINUTILS}.tar.xz &&
tar xf ${BINUTILS}.tar.xz &&

echo "\n\nConfigure ${MYNAME} ...\n" &&
mkdir -p ${BINUTILS}/obj-avr && cd ${BINUTILS}/obj-avr &&
../configure --prefix="$PREFIX" --target=avr --host=amd64 --build=amd64 --disable-nls --disable-doc --quiet > /dev/null &&

echo "\n\nBuild ${MYNAME} ...\n" &&
make -j $JOBCOUNT > /dev/null &&

echo "\n\nInstall ${MYNAME} ...\n" &&
make install > /dev/null &&

cd ../../ &&
echo ""
