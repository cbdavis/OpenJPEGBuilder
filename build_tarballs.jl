# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "OpenJPEGBuilder"
version = v"2.3.1"

# Collection of sources required to build OpenJPEGBuilder
sources = [
    "https://github.com/uclouvain/openjpeg.git" =>
    "9b7620ee7a3d72bfcdbebd78e607c5ee8aa7fade",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd openjpeg/
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install
make clean
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libopenjp2", :libopenjp2),
    ExecutableProduct(prefix, "opj_decompress", :opj_decompress),
    ExecutableProduct(prefix, "opj_dump", :opj_dump),
    ExecutableProduct(prefix, "opj_compress", :opj_compress)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

