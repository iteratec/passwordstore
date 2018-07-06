#!/bin/bash

# This entrypoint 
#   * Adds gpg private key which have to be mounted into the container.
#   * Adds passphrase of the key to gpg-agent. Passphrase has to be mounted
#     into the container, too.
#   * Calls gopath with given password entry name (must be given by the user as docker CMD) to show 
#     entries password.

gpg --import --passphrase $PASSPHRASE /tmp/key.asc &> /dev/null
for Keygrip in $(gpg --with-keygrip -K | awk -F"[ =]+" '/Keygrip/{print $3}'); do 
    /usr/lib/gnupg2/gpg-preset-passphrase -c --passphrase $PASSPHRASE $Keygrip; 
done

DOCKER_CMD=$1
if [ -z "$DOCKER_CMD" ]; then
    echo "Usage: docker run ... iteratec/passwordstore <name-of-passwordstore-entry>"
else
    gopass show --password $DOCKER_CMD
fi