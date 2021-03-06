  #!/bin/bash
# https://www.nongnu.org/avr-libc/user-manual/install_tools.html#install_avr_gcc
# build the code on --build, run it on --host with --target architecture environment.

# Make AVR-GCC
MYNAME="avr-gcc"
echo "\n*** Making ${MYNAME} ***\n"

# Handle cache
$PREFIX/bin/avr-gcc --version || true
IS_GCC=$($PREFIX/bin/avr-gcc --version | sed -n "/${VER_GCC}/p")
if [ -n "$IS_GCC" ] ; then
  echo "\n  --> ${MYNAME} is already OK for version ${VER_GCC} --> We will not build it.\n"
  exit 0
fi

echo "\n\nDownloading and extracting ${MYNAME} ...\n"
wget http://mirror.rit.edu/gnu/gcc/${GCC}/${GCC}.tar.xz > /dev/null &&
tar xf ${GCC}.tar.xz > /dev/null &&

echo "\n\nInstalling dependencies for ${MYNAME} ...\n" &&
mkdir -p ${GCC}/obj-avr && cd ${GCC} &&
sed -i 's/ftp:\/\/gcc\.gnu\.org/http:\/\/gcc\.gnu\.org/' ./contrib/download_prerequisites &&
./contrib/download_prerequisites &&

echo "\n\nConfigure ${MYNAME} ...\n" &&
cd obj-avr &&
../configure --prefix="$PREFIX" --disable-doc --quiet --enable-device-lib --build=amd64 --host=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --disable-libada --disable-shared --enable-static > /dev/null &&

echo "\n\nBuild ${MYNAME} ...\n" &&
make -j $JOBCOUNT > /dev/null &&

echo "\n\nInstall ${MYNAME} ...\n" &&
make install > /dev/null &&

cd ../../ &&
echo ""
