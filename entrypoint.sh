#!/bin/sh
set -e

dpkg --add-architecture $1
apt-get update
apt-get install -y crossbuild-essential-$1

apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -a$1 .
# Build the package
echo "Package building is started!"
dpkg-buildpackage -b $2 --host-arch $1 || true
echo "Package is built!"
# Output the filename
cd ..
filename_lib=`ls *.deb | grep -v "dev"`
filename_dev=`ls *.deb | grep "dev"`
echo ::set-output name=filename-lib::$filename_lib
echo ::set-output name=filename-dev::$filename_dev
# Move the built package into the Docker mounted workspace
mv $filename_lib workspace/
mv $filename_dev workspace/
