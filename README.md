# passwordstore

This is an image to use [passwordstore](https://www.passwordstore.org) as a command line tool to decrypt passwords from a store.

It can be used in contexts of automation, like CI Pipelines.

To read/decrypt a password from the store one can use the image/container like an executable:

        docker run \
            -v </path/to/local/.password-store>:/root/.password-store \
            -v </path/to/private/gpg_key.asc>:/tmp/key.asc \
            -e PASSPHRASE=<passphrase_of_key> \
            iteratec/passwordstore <name_of_password_to_decrypt>

The gpg private key can be exported via

        gpg2 --export-secret-key -o gpg_key.asc <ID_of_your_key>