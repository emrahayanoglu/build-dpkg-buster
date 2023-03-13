FROM debian:buster
LABEL maintainer="David Baumgold <david@davidbaumgold.com>"

ARG INPUT_ARCHITECTURE
RUN echo "Incoming Architecture ${INPUT_ARCHITECTURE}"
ENV INPUT_ARCHITECTURE $INPUT_ARCHITECTURE

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Installs the `dpkg-buildpackage` command
RUN apt-get update
RUN apt-get install build-essential debhelper devscripts -y

RUN dpkg --add-architecture $INPUT_ARCHITECTURE
RUN apt-get update
RUN apt-get install -y crossbuild-essential-$INPUT_ARCHITECTURE

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
