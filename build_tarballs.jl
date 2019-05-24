# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "OpenJPEG"
version = v"2.3.1"  # also change in script below

# Collection of sources required to build OpenJPEGBuilder
sources = [
    "https://github.com/uclouvain/openjpeg/archive/v2.3.1.tar.gz" =>
    "63f5a4713ecafc86de51bfad89cc07bb788e9bba24ebbf0c4ca637621aadb6a9",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd openjpeg-2.3.1
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install
make clean
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

