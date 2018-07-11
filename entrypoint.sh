#!/bin/bash

# This entrypoint 
#   * gpg key is decrypted using passphrase given as env var $PASSPHRASE if env var $KEY_ENCRYPTED is set to true. 
#   * Adds gpg private key which have to be mounted into the container.
#   * Adds passphrase of the key to gpg-agent.
#   * Calls gopath with given password entry name (must be given by the user as docker CMD) to show 
#     entries password.

KEY_TO_USE="/tmp/key.asc"
if [ "$KEY_ENCRYPTED" = true ]; then
    echo $PASSPHRASE | gpg -o /tmp/key_decrypted.asc --passphrase-fd 0 /tmp/key.asc &> /dev/null
    KEY_TO_USE="/tmp/key_decrypted.asc"
fi
gpg --import --passphrase $PASSPHRASE $KEY_TO_USE &> /dev/null
for Keygrip in $(gpg --with-keygrip -K | awk -F"[ =]+" '/Keygrip/{print $3}'); do 
    /usr/lib/gnupg2/gpg-preset-passphrase -c --passphrase $PASSPHRASE $Keygrip; 
done

DOCKER_CMD=$1
if [ -z "$DOCKER_CMD" ]; then
    echo "Usage: docker run ... iteratec/passwordstore <name-of-passwordstore-entry>"
    exit 1
else
    gopass show --password $DOCKER_CMD
fi