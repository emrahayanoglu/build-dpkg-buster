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
filename=`ls *.deb | grep -v -- -dbgsym`
dbgsym=`ls *.deb | grep -- -dbgsym`
echo ::set-output name=filename::$filename
echo ::set-output name=filename-dbgsym::$dbgsym
# Move the built package into the Docker mounted workspace
mv $filename $dbgsym workspace/
