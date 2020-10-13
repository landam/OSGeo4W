export P=exiv2
export V=0.27.3
export B=next
export MAINTAINER=JuergenFischer
export BUILDDEPENDS="expat-devel zlib-devel libiconv-devel"

source ../../../scripts/build-helpers

startlog

[ -f $P-$V-Source.tar.gz ] || wget https://www.exiv2.org/builds/$P-$V-Source.tar.gz
[ -f ../CMakeLists.txt ] || tar -C .. -xzf  $P-$V-Source.tar.gz --xform "s,^$P-$V-Source,.,"

vs2019env
cmakeenv
ninjaenv

mkdir -p build install

cd build

cmake -G Ninja \
	-D CMAKE_BUILD_TYPE=Release \
	-D ZLIB_LIBRARY=$(cygpath -am ../osgeo4w/lib/zlib.lib) \
	-D ZLIB_INCLUDE_DIR=$(cygpath -am ../osgeo4w/include) \
	-D EXPAT_LIBRARY=$(cygpath -am ../osgeo4w/lib/libexpat.lib) \
	-D EXPAT_INCLUDE_DIR=$(cygpath -am ../osgeo4w/include) \
	-D Iconv_LIBRARY=$(cygpath -am ../osgeo4w/lib/iconv.dll.lib) \
	-D Iconv_INCLUDE_DIR=$(cygpath -am ../osgeo4w/include) \
	-D EXIV2_BUILD_SAMPLES=OFF \
	-D CMAKE_INSTALL_PREFIX=../install \
	../..
ninja
ninja install

cd ..

export R=$OSGEO4W_REP/x86_64/release/$P
mkdir -p $R/$P-devel $R/$P-tools

cat <<EOF >$R/setup.hint
sdesc: "Image metadata library (runtime)"
ldesc: "Image metadata library (runtime)"
maintainer: JuergenFischer
category: Libs
requires: msvcrt2019 expat zlib libiconv
EOF

cat <<EOF >$R/$P-devel/setup.hint
sdesc: "Image metadata library (development)"
ldesc: "Image metadata library (development)"
maintainer: $MAINTAINER
category: Libs
requires: $P
external-source: $P
EOF

cat <<EOF >$R/$P-tools/setup.hint
sdesc: "Image metadata library (tools)"
ldesc: "Image metadata library (tools)"
maintainer: $MAINTAINER
category: Commandline_Utilities
requires: $P
external-source: $P
EOF

tar -C install -cjf $R/$P-devel/$P-devel-$V-$B.tar.bz2 include lib share
tar -C install -cjf $R/$P-tools/$P-tools-$V-$B.tar.bz2 --exclude "*.dll" bin
tar -C install -cjf $R/$P-$V-$B.tar.bz2 --exclude "*.exe" bin
tar -C .. -cjf $R/$P-$V-$B-src.tar.bz2 osgeo4w/package.sh

cp ../COPYING $R/$P-devel/$P-devel-$V-$B.txt
cp ../COPYING $R/$P-tools/$P-tools-$V-$B.txt
cp ../COPYING $R/$P-$V-$B.txt

endlog
