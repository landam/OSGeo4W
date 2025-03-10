export P=python3-pdal
export V=pip
export B=pip
export MAINTAINER=JuergenFischer
export BUILDDEPENDS="python3-pip python3-wheel python3-devel python3-setuptools python3-numpy python3-pybind11 python3-packaging python3-pyparsing pdal-devel"

source ../../../scripts/build-helpers

startlog

cd ..

if [ -d pdalextension ]; then
	cd pdalextension
	git pull
else
	git clone https://github.com/PDAL/python pdalextension
	cd pdalextension
fi

cd $OSGEO4W_PWD

fetchenv osgeo4w/bin/o4w_env.bat

vs2019env
cmakeenv
ninjaenv

pip3 install scikit_build

cat <<EOF >pip.env
EOF

export INCLUDE="$(cygpath -am osgeo4w/include);\$INCLUDE"
export LIB="$(cygpath -am osgeo4w/lib);\$LIB"
export CMAKE_PREFIX_PATH="$(cygpath -am osgeo4w/apps/Python39/Lib/site-packages/pybind11)"

cd ../pdalextension

pip3 install .

adddepends=pdal packagewheel $(cygpath -am $PWD)

endlog
