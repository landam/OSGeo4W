export P=python3-nose2
export V=pip
export B=pip
export MAINTAINER=JuergenFischer
export BUILDDEPENDS="python3-pip python3-wheel python3-setuptools python3-six python3-coverage"

source ../../../scripts/build-helpers

startlog

packagewheel

endlog
