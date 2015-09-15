# Bash utils
. $IncludeOS_src/etc/set_traps.sh

mkdir -p $BUILD_DIR
cd $BUILD_DIR

if [ ! -f binutils-$binutils_version.tar.gz ]; then
    echo -e "\n\n >>> Getting binutils into `pwd` \n"
    wget -c --trust-server-name ftp://ftp.uninett.no/pub/gnu/binutils/binutils-$binutils_version.tar.gz
fi

if [ ! -f gcc-$gcc_version.tar.gz ]; then
    echo -e "\n\n >>> Getting GCC \n"
    wget -c --trust-server-name ftp://ftp.uninett.no/pub/gnu/gcc/gcc-$gcc_version/gcc-$gcc_version.tar.gz
fi

if [ ! -d binutils-$binutils_version ]; then
    echo -e "\n\n >>> Extracting binutils \n"
    tar -xf binutils-$binutils_version.tar.gz
else
    echo -e "\n\n >>> SKIP: Extracting binutils  \n"
fi

if [ ! -d build_binutils ]; then
    echo -e "\n\n >>> Configuring binutils \n"
    mkdir -p build_binutils
    cd build_binutils
    ../binutils-$binutils_version/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-werror
    
    echo -e "\n\n >>> Building binutils \n" 
    make $num_jobs
    
    echo -e "\n\n >>> Installing binutils \n"    
    sudo -E  make install

else
    echo -e "\n\n >>> SKIP: Configure / build binutils. Seems to be there  \n"
fi

# UNPACK GCC

if [ ! -d gcc-$gcc_version ]; then
    echo -e "\n\n >>> Unpacking GCC source \n"
    cd $BUILD_DIR
    tar -xf gcc-$gcc_version.tar.gz

    # GET GCC PREREQS 
    echo -e "\n\n >>> Getting GCC Prerequisites \n"
    pushd gcc-$gcc_version/    
    ./contrib/download_prerequisites
    popd
else
    echo -e "\n\n >>> SKIP: Unpacking GCC + getting prerequisites Seems to be there \n"
fi

cd $BUILD_DIR

if [ ! -d build_gcc ]; then
    mkdir -p build_gcc
    cd build_gcc

    echo -e "\n\n >>> Configuring GCC \n"
    ../gcc-$gcc_version/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers

    echo -e "\n\n >>> Building GCC \n"
    make all-gcc $num_jobs

    echo -e "\n\n >>> Installing GCC (Might require sudo) \n"
    sudo -E make install-gcc

    echo -e "\n\n >>> Building libgcc for target $TARGET \n"
    make all-target-libgcc $num_jobs

    echo -e "\n\n >>> Installing libgcc (Might require sudo) \n"
    sudo -E make install-target-libgcc

else
    echo -e "\n\n >>> SKIP: Building / Installing GCC + libgcc. Seems to be ok \n" 
fi

trap - EXIT
