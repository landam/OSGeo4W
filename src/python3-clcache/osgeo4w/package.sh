export P=python3-clcache
export V=pip
export B=pip
export MAINTAINER=JuergenFischer
export BUILDDEPENDS="python3-pip python3-wheel python3-setuptools python3-pyuv python3-pymemcache"

source ../../../scripts/build-helpers

startlog

packagewheel

endlog
