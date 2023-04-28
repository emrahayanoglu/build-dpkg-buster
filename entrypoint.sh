#!/bin/sh
set -e

dpkg --add-architecture $1
apt-get update
apt-get install -y crossbuild-essential-$1
apt-get install -y libc6-dev:$1
apt-get install -y libstdc++6:$1

cd paho.mqtt.c
apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -a$1 .
# Build the package
echo "Package building is started!"
dpkg-buildpackage -b $2 --host-arch $1 || true
echo "Package is built!"

cd ..
dpkg -i *.deb

cd main
apt-get -o Debug::pkgProblemResolver=yes -y --force-yes build-dep -a$1 .
# Build the package
echo "Package building is started!"
dpkg-buildpackage -b $2 --host-arch $1 || true
echo "Package is built!"

# Output the filename
cd ..
ls -l *.deb
